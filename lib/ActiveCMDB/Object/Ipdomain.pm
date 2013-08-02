package ActiveCMDB::Object::Ipdomain;

=head1 MODULE - ActiveCMDB::Object::Ipdomain
    ___________________________________________________________________________

=head1 VERSION

    Version 1.0

=head1 COPYRIGHT

    Copyright (C) 2011-2015 Theo Bot

    http://www.activecmdb.org


=head1 DESCRIPTION

    Class definition

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

=head1 IMPORTS

 
=cut

use Moose;
use Data::Dumper;
use Try::Tiny;
use ActiveCMDB::Model::CMDBv1;

=head1 ATTRIBUTES


=cut

has domain_id	=> (
	is		=> 'rw',
	isa		=> 'Int'
);
has domain_name	=> (
	is		=> 'rw',
	isa		=> 'Str'
);

has active		=> (
	is		=> 'rw',
	isa		=> 'Bool',
	default	=> 0
);

has resolvers	=> (
	is		=> 'rw',
	isa		=> 'Maybe[Str]'
);

has auto_update	=> (
	is		=> 'rw',
	isa		=> 'Bool',
	default	=> 0
);

has schema 		=> (
	is 		=> 'rw',
	isa		=> 'Object',
	default	=> sub { ActiveCMDB::Model::CMDBv1->instance() }
);

my %map = (
	domain_id	=> 'domain_id',
	domain_name	=> 'domain_name',
	active		=> 'active',
	resolvers	=> 'resolvers',
	auto_update	=> 'auto_update'
	);

sub get_data
{
	my($self) = @_;
	
	if ( defined($self->domain_id) )
	{
		try {
			my $row = $self->schema->resultset('IpDomain')->find({ domain_id => $self->domain_id} );
			if ( defined($row) )
			{
				foreach my $attr (keys %map)
				{
					my $field = $map{$attr};
					if ( defined($row->$field) ) {
						$self->$attr($row->$field);
					}
				}
				Logger->debug("Fetched ipdomain data");
			}
		} catch {
			Logger->warn("Failed to fetch domain data: " . $_);
		};
		
	}
}