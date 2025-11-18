# Sentry Laravel Issue #1064 Reproduction Attempt

This github repo is an attempt to recreate the issue in [Sentry Laravel Integration Issue #1064](https://github.com/getsentry/sentry-laravel/issues/1064)

## Requirements
- Sentry DSN and Domain
- GitHub Codespaces OR Docker Desktop
  - tested on MacOS, but should work on other OSes

## Instructions
First, copy the .env.example to .env

```shell
cp .env.example .env
```

Then, edit the .env file in your favorite editor to add the correct values to
- SENTRY_LARAVEL_DSN
- SENTRY_DOMAIN

Then, edit the `.env` file in your favorite editor to add the correct values. In
GitHub Codespaces or VS Code's Markdown preview you can click the link to open
the file in the editor:

- [Open `.env`](./.env)

Add the following variables to `.env`:
- `SENTRY_LARAVEL_DSN`
- `SENTRY_DOMAIN`

Then, in terminal, execute the test.sh script.

```shell
./test.sh
```
(This can be run in VSCode via the ["Run Task: Run test.sh"](command:workbench.action.tasks.runTask?%5B%22Run%20test.sh%22%5D).)

After a bit, this should pop a browser to the sentry trace waterfall generated for the [Sentry Laravel Integration Issue #1064](https://github.com/getsentry/sentry-laravel/issues/1064), if it hasn't processed fully yet, you may have to refresh the page after a few more seconds.