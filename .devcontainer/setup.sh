#!/bin/bash
if [ ! -f .env ]; then
    echo --- Copy the environment file ...
    cp .env.example .env
fi

echo "--- Install dependencies (first sail install will take a while) ..."
composer install

echo "--- Start sail containers ..."
./vendor/bin/sail up -d

echo "--- Generate the application key ..."
./vendor/bin/sail php artisan key:generate

echo "--- Install npm packages ..."
./vendor/bin/sail npm install

echo "--- Stop sail containers ..."
./vendor/bin/sail down -v

echo "--- SETUP DONE ---"
echo "--- Please read README.md to start reproducing the github issue ---"
