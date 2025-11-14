<?php

namespace App\Jobs;

use App\Console\Commands\Crash;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Artisan;

class CallArtisanCrash implements ShouldQueue
{
    use Queueable;

    /**
     * Create a new job instance.
     */
    public function __construct()
    {
        //
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        logger()->info('Calling Artisan command Crash from Job.');

        Artisan::call(Crash::class);
    }
}
