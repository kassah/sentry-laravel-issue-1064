#!/bin/zsh
# Turn on stop on error.
set -e

# Ensure docker is running.
(docker info > /dev/null 2>&1) || (echo "Docker is not running."; exit 1)

# We need composer dependencies before we can proceed.
if [ ! -d vendor ]; then
    echo "Installing composer dependencies."
    docker run --rm \
        --pull=always \
        -v "$(pwd)":/opt \
        -w /opt \
        laravelsail/php84-composer:latest \
        bash -c "composer install --no-interaction"
    chmod u+x vendor/bin/sail
    chmod u+x vendor/laravel/sail/bin/sail
fi

# Load Laravel Environment
source .env
# Teardown sail (ignore error)
(./vendor/bin/sail down -v || true)
# Remove logs (ignore error)
(rm storage/logs/*.log || true)
# Bring up sail
./vendor/bin/sail up -d
# Wait for database port to be open.
docker compose exec mysql bash -c "echo -n 'Waiting for MySQL to be ready.'; until (mysqladmin ping -h 127.0.0.1 -P 3306 -p${DB_PASSWORD} 2> /dev/null) ; do echo -n '.'; sleep 1; done; echo ''"
# Migrate the database
./vendor/bin/sail artisan migrate:fresh --force
# Seed the tenant
./vendor/bin/sail artisan db:seed
# Sleep for 5 and then cause the error.
zsh -ec "(sleep 5; docker compose exec -T laravel.test curl http://localhost/artisan)" &
error_pid=$!
(./vendor/bin/sail logs -f) &
sail_log_pid=$!
zsh -ec "(until [ -f storage/logs/sentry.log ]; do; sleep 0.1; done; tail -f storage/logs/sentry.log | grep -v 'PHP setting is enabled which results in missing stack trace arguments' | grep -v 'integration(s) have been installed.' )" &
sentry_log_pid=$!
zsh -ec "(until [ -f storage/logs/laravel.log ]; do; sleep 0.1; done; tail -f storage/logs/laravel.log)" &
laravel_log_pid=$!
(
  openurl() {
      url=$1
      echo " === Open URL: $url === "
      (start "$1" || xdg-open "$1" || open "$1") 2> /dev/null
  }
  until (grep -m 1 "was started and sampled, decided by config:traces_sample_rate." storage/logs/sentry.log 2> /dev/null)
  do
    sleep 1
  done
  trace_id=$(grep -m 1 "was started and sampled, decided by config:traces_sample_rate." storage/logs/sentry.log | cut -d " " -f 4 | cut -d "[" -f 2 | cut -d "]" -f 1)
  sentry_project_id=$(echo "${SENTRY_LARAVEL_DSN}" | cut -d "/" -f 3 | cut -d "." -f 1 | cut -d "@" -f 2 | cut -d "o" -f 2)
  sleep 20
  openurl ${SENTRY_DOMAIN}/explore/traces/trace/${trace_id}/\?environment=${SENTRY_ENVIRONMENT}\&mode=samples\&pageEnd\&pageStart\&project=${sentry_project_id}\&query=&source=traces\&statsPeriod=1h\&table=trace
) &
sentry_url_pid=$!

function ctrl_c() {
        echo "** Trapped CTRL-C"
        if [ -n "$error_pid" ]; then
            kill $error_pid || true
        fi
        if [ -n "$sail_log_pid" ]; then
            kill $sail_log_pid || true
        fi
        if [ -n "$sentry_log_pid" ]; then
            kill $sentry_log_pid || true
        fi
        if [ -n "$laravel_log_pid" ]; then
            kill $laravel_log_pid || true
        fi
        if [ -n "$sentry_url_pid" ]; then
            kill $sentry_url_pid || true
        fi
        wait $error_pid $worker_pid $sentry_log_pid $laravel_log_pid
        echo "Closed down all dependent processes. Exiting."
        exit 0
}
trap ctrl_c INT

echo " === Hit Ctrl-C to exit === "
# Sleep to the end of time waiting for the Ctrl-C
while sleep 1
do
    sleep 1
done
