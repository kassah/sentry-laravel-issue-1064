<?php

namespace App\Jobs;

use App\Console\Commands\Crash;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Artisan;
use Spatie\Multitenancy\Models\Tenant;

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
        $spanContext = \Sentry\Tracing\SpanContext::make()
            ->setOp('debug-tenants-call')
            ->setDescription('Call Artisan Crash through tenants:artisan command.');
        \Sentry\trace(function () {
            $tenant = Tenant::firstOrFail()->id;
            Artisan::call("tenants:artisan --tenant={$tenant} \"crash\"");
            //Artisan::call(Crash::class);
        }, $spanContext);
    }
}
