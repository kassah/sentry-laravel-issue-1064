#!/bin/bash -e
# Start from a clean slate.
rm -f .env.temp || true
# Grab the sentry dsn and domain.
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "Please enter your Sentry DSN: "
    read SENTRY_LARAVEL_DSN
    echo "Please enter the first part of your sentry url ( i.e. https://yourslug.sentry.io ): "
    read SENTRY_DOMAIN
    APP_KEY="base64:6bwI3Il3bcIV1ZstINMxvLM9rH5sixlhEmspUuqx7r0="
else
    source .env
    if [ -z "$SENTRY_LARAVEL_DSN" ]; then
        echo "Please enter your Sentry DSN "
        read SENTRY_LARAVEL_DSN
    fi
    if [ -z "$SENTRY_DOMAIN" ]; then
        echo "Please enter the first part of your sentry url ( i.e. https://yourslug.sentry.io ): "
        read SENTRY_DOMAIN
    fi
    if [[ "$SENTRY_DOMAIN" == "https://yourslug.sentry.io" ]]; then
            echo "Please enter the first part of your sentry url ( i.e. https://yourslug.sentry.io ): "
            read SENTRY_DOMAIN
        fi
fi

cp .env.example .env.temp

# Set Sentry DSN in the temp
sed -i.old '/^SENTRY_LARAVEL_DSN/d' .env.temp
echo "SENTRY_LARAVEL_DSN=$SENTRY_LARAVEL_DSN" >> .env.temp
rm .env.temp.old

# Set Sentry Domain in the temp
sed -i.old '/^SENTRY_DOMAIN/d' .env.temp
echo "SENTRY_DOMAIN=$SENTRY_DOMAIN" >> .env.temp
rm .env.temp.old

if [ -n "$APP_KEY" ]; then
    sed -i.old '/^APP_KEY/d' .env.temp
    echo "APP_KEY=$APP_KEY" >> .env.temp
    rm .env.temp.old
fi

# Put our updated env file over the local .env
mv -f .env.temp .env
