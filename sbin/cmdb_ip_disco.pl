#!/usr/bin/env perl

=begin nd

    Script: cmdb_ip_disco.pl
    ___________________________________________________________________________

    Version 1.0

    Copyright (C) 2011-2015 Theo Bot

    http://www.activecmdb.org


    Topic: Purpose

    IP Device Discovery Manager

    About: License

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    Topic: Release information

    $Rev$

=cut

use v5.16.0;
use ActiveCMDB::Tools::DiscoProcessor;
use ActiveCMDB::Common::Constants;
use sigtrap qw(handler sigHandler INT TERM);
use Getopt::Long;
use Logger;

my $discovery;

END {
	$discovery->process->cleanup();
}
#
# Process arguments
#
our $instance;
our $device;
my $result = GetOptions (
	"instance=i"	=> \$instance,
	"device=s"		=> \$device
	);
if ( !defined($instance)) {
	Logger->warn("No instance defined");
	exit 1;
}

$ENV{INSTANCE} = $instance;

$discovery = ActiveCMDB::Tools::DiscoProcessor->new({ instance => $instance });
#
# Initialize myself
#
$discovery->init({ instance => $instance});
if ( !defined($device) )
{
	Logger->info("Entering main processing loop");
	$discovery->processor();
} else {
	Logger->info("Start discovering $device");
	$discovery->discover_device($device);
}
Logger->info("Exitting");
exit;

sub sigHandler
{
	my $signal = shift;
	$discovery->raise_signal($signal);
}