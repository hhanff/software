#!/usr/bin/perl -w
use strict;
use Device::SerialPort;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($DEBUG);

my $serial = Device::SerialPort->new("/dev/ttyUSB0") || die $!;

open FILE, ">>values.txt" or die;

$serial->baudrate(9600);
$serial->databits(8);
$serial->purge_all();
$serial->rts_active(0);
$serial->dtr_active(1);


# Autoflush
select FILE;
$| = 1;

my $cnt = 0;

while(1) {
    $cnt = $cnt+1;
    # Send request
    $serial->write("n");

    # Read response
    my($count, $data) = $serial->read(14);
    print FILE time(), " $cnt ", "$data", "\n";

    # Wait one second
    select(undef, undef, undef, 1);
}
