package ActiveCMDB::Common::Constants;

=head1 MODULE - ActiveCMDB::Common::Constants
    ___________________________________________________________________________

=head1 VERSION

    Version 1.0

=head1 COPYRIGHT

    Copyright (C) 2011-2015 Theo Bot

    http://www.activecmdb.org


=head1 DESCRIPTION

    Definition of global constants

=head1 LICENSE

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

=cut

use Exporter;
use vars qw($cfg_state, $objects_mapper);

@ISA = ('Exporter');
@EXPORT = qw( 
				PROC_SHUTDOWN PROC_RUNNING PROC_DISABLED PROC_IDLE PROC_BUSY
				MSG_TYPE_JSON	SNMP_LARGE_IFTABLE
				OID_SYSOBJECTID
				true false TRUE FALSE TCP_TIMEOUT
				PRIO_HIGH PRIO_LOW PRIO_NORMAL
				$m_repeat $cfg_state $objects_mapper
				HTTP_OK HTTP_UNAUTHORIZED HTTP_INTERNAL_ERROR
			);


			
#
# Process states
#
use constant PROC_SHUTDOWN	=> 1;	# Process is stopped
use constant PROC_RUNNING	=> 2;	# Process is running
use constant PROC_DISABLED	=> 3;	# Process is disabled
use constant PROC_IDLE		=> 4;	# Process is idle
use constant PROC_BUSY		=> 5;	# Process is busy

#
# Message constants
#
use constant MSG_TYPE_JSON => 'application/json';

#
# Other
#
use constant true  => 1;
use constant TRUE  => 1;
use constant false => 0;
use constant FALSE => 0;
use constant TCP_TIMEOUT => 5;

#
# SNMP Basic OIDS
#
use constant OID_SYSOBJECTID => '1.3.6.1.2.1.1.2.0';

use constant SNMP_LARGE_IFTABLE	=> 1000;

#
# Messaging
#
use constant	PRIO_HIGH	=> 7;
use constant	PRIO_LOW	=> 0;
use constant	PRIO_NORMAL	=> 4;

#
# HTTP Status code
#
use constant	HTTP_OK				=> 200;
use constant	HTTP_BAD_REQUEST	=> 400;
use constant	HTTP_UNAUTHORIZED	=> 401;
use constant	HTTP_INTERNAL_ERROR	=> 500;

# 
# Config states
#
$cfg_state = {
				0	=> 'Available',
				1	=> 'Broken',
				2	=> 'Locked'
};

#
# Object types
# 
$objects_mapper = {
				'device'	=> 'ActiveCMDB::Object::Device',
				'vendor'	=> 'ActiveCMDB::Object::Vendor',
				'message'	=> 'ActiveCMDB::Object::Message'
}