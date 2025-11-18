# Sentry Laravel Issue #1064 Reproduction Attempt

This github repo is an attempt to recreate the issue in [Sentry Laravel Integration Issue #1064](https://github.com/getsentry/sentry-laravel/issues/1064)

## Requirements
- Docker Desktop (tested on MacOS)

## Instructions
First, copy the .env.example to .env

```shell
cp .env.example .env
```

Then, edit the .env file in your favorite editor to add the correct values to
- SENTRY_LARAVEL_DSN
- SENTRY_DOMAIN

then, in terminal, execute the test.sh script.

```shell
./test.sh
```
