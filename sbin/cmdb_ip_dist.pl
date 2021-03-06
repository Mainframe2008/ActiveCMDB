#!/usr/bin/env perl

=begin nd

    Script: cmdb_ip_dist.pl
    ___________________________________________________________________________

    Version 1.0

    Copyright (C) 2011-2015 Theo Bot

    http://www.activecmdb.org


    Topic: Purpose

    IP Device Distribution Manager

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
use ActiveCMDB::Tools::Distributor;
use ActiveCMDB::Common::Constants;
use sigtrap qw(handler sigHandler INT TERM);
use Getopt::Long;
use Logger;

my $distributor;

END {
	$distributor->process->cleanup();
}

#
# Process arguments
#
our $instance;
my $result = GetOptions ("instance=i" => \$instance);
if ( !defined($instance) ) {
	Logger->warn("No instance defined");
	exit 1;
}
$ENV{INSTANCE} = $instance;

$distributor = ActiveCMDB::Tools::Distributor->new({ instance => $instance });
#
# Initialize myself
#
$distributor->init({ instance => $instance});
$distributor->processor();

Logger->info("Exitting");
exit;

sub sigHandler
{
	my $signal = shift;
	$distributor->raise_signal($signal);
}