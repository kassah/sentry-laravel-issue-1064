<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use RuntimeException;

class Crash extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'crash';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Throw an exception.';

    /**
     * Execute the console command.
     */
    public function handle(): void
    {
        logger()->info('Executing Crash command to throw an exception.');

        throw new RuntimeException('This is a test exception from the Crash command.');
    }
}
