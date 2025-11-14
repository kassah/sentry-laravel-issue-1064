<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('artisan', function () {
    logger()->info('Dispatching artisan crash job');

    dispatch(new \App\Jobs\CallArtisanCrash);

    return 'Dispatched!';
});
