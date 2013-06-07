package ActiveCMDB::Controller::Ipdomain;
use Moose;
use namespace::autoclean;
use POSIX;
use Data::Dumper;
use NetAddr::IP;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ActiveCMDB::Controller::Ipdomain - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=ead2 index

=cut

sub index :Private {
    my ( $self, $c ) = @_;

	my @domains = ();

    my $rs =	$c->model('CMDBv1::IpDomain')->search(
    								{},
    								{
    									join	 => 'ip_domain_networks',
    									select	 => [ 'domain_id', 'domain_name', { count => 'ip_domain_networks.domain_id' } ],
    									as		 => [ qw/domain_id domain_name tally/ ],
    									group_by => [ qw/ domain_id/ ]
    								}
    							);
    
    while ( my $row = $rs->next )
    {
    	push(@domains, { domain_id => $row->domain_id, name => $row->domain_name, tally => $row->get_column('tally') });
    }
    
    $c->stash->{domains} = [ @domains ];
    $c->stash->{template} = 'domain/list.tt';
}

sub view :Local {
	my( $self, $c ) = @_;
	my($domain_id, $rs, $row);
	my @networks = ();
	
	$domain_id = $c->request->params->{domain_id} || undef;
	
	if ( defined($domain_id) )
	{
		$c->stash->{domain} = $c->model('CMDBv1::IpDomain')->find({ domain_id => $domain_id });
		
		$rs = $c->model('CMDBv1::IpDomainNetwork')->search(
					{
						domain_id => $domain_id
					},
					{
						order_by => [ qw/ip_network/ ]
					}
			);
			
		while ( $row = $rs->next )
		{
			push(@networks, $row);
		}
		$c->stash->{networks} = [ @networks ];
		
	}
	
	$c->stash->{template} = 'domain/view.tt';
	
	
}


sub network :Local {
	my($self, $c ) = @_;
	
	if ( defined($c->request->params->{oper}) ) {
		$c->forward($c->request->params->{oper});
	}
}

sub list :Local {
	my($self, $c) = @_;
	
	my ($rs,$search);
	my @data = ();
	my @rows = ();
	
	my $json = undef;
	
	my $id 		= $c->request->params->{domain_id} || 0;
	my $rows	= $c->request->params->{rows} || 10;
	my $page	= $c->request->params->{page} || 1;
	my $order	= $c->request->params->{sidx} || 'domain_id';
	my $asc		= '-' . $c->request->params->{sord};
	
	
	#
	# Create search filter
	#
	if ( $c->request->params->{_search} eq 'true' )
	{
		my $searchOper   = $c->request->params->{searchOper};
		my $searchField  = $c->request->params->{searchField};
		my $searchString = $c->request->params->{searchString};
		if ( $searchOper eq 'cn' ) {
			$search = { $searchField => { like => '%'.$searchString.'%' } };
		}
		if ( $searchOper eq 'eq' ) {
			$search = { $searchField => $searchString };
		}
		if ( $searchOper eq 'ne' ) {
			$search = { $searchField => { '!=' => $searchString } };
		}
		
	} else {
		$search = { domain_id => $id };
	}
	
	#
	# Get total for the query
	#
	$json->{records} = $c->model('CMDBv1::IpDomainNetwork')->search( $search )->count;
	if ( $json->{records} > 0 ) {
		$json->{total} = ceil($json->{records} / $rows );
	} else {
		$json->{total} = 0;
	} 
	
	
	#
	# Get the data
	#
	$rs = $c->model('CMDBv1::IpDomainNetwork')->search(
				$search,
				{
					order_by => { $asc => $order },
					rows	 => $rows,
					page	 => $page
				}
			);
			
	while ( my $row = $rs->next )
	{
		push(@rows, { id => $row->network_id, cell=> [	
														$row->ip_network,
														$row->ip_mask,
														$row->ip_masklen,
														$row->active,
														$row->snmp_ro || "",
														$row->snmp_rw || "",
														$row->telnet_user || "",
														$row->telnet_pwd || "",
														$row->snmpv3_user || "",
													] 
					}
			);
	}
	$json->{rows} = [ @rows ];
	#$c->log->debug(Dumper($json));
	$c->stash->{json} = $json;
	
	
	$c->forward( $c->view('JSON') );
}

sub edit :Local {
	my($self, $c) = @_;
	my($data,$rs,$net);
	
	$data = undef;
	foreach my $f (qw/domain_id ip_network ip_mask ip_masklen active snmp_ro snmp_rw telnet_user telnet_pwd snmpv3_user snmpv3_pass1 snmpv3_pass2 snmpv3_proto1 snmpv3_proto2/)
	{
		$data->{$f} = $c->request->params->{$f};
	}
	$data->{network_id} = $c->request->params->{id};
	$net = NetAddr::IP->new($data->{ip_network});
	if ( !defined($data->{ip_mask}) && defined($data->{ip_masklen}) )
	{
		$net = NetAddr::IP->new($data->{ip_network} . '/' . $data->{ip_masklen});
		$data->{ip_mask} = $net->mask();
	} elsif ( defined($data->{ip_mask}) && !defined($data->{ip_masklen}) ) {
		$net = NetAddr::IP->new($data->{ip_network}, $data->{ip_mask});
		$data->{ip_masklen} = $net->masklen();
		
	}
	
	if ( $data->{active} eq 'Yes' ) { $data->{active} = 1; } else { $data->{active} = 0; }
	$c->model('CMDBv1::IpDomainNetwork')->update_or_create( $data );
	$c->response->status(200);
	$c->response->body('');
}

sub add :Local {
	my($self, $c) = @_;
	
	my($data,$rs,$net);
	
	$data = undef;
	foreach my $f (qw/domain_id ip_network ip_mask ip_masklen active snmp_ro snmp_rw telnet_user telnet_pwd snmpv3_user snmpv3_pass1 snmpv3_pass2 snmpv3_proto1 snmpv3_proto2/)
	{
		$data->{$f} = $c->request->params->{$f};
	}
	$data->{network_id} = undef;
	$net = NetAddr::IP->new($data->{ip_network});
	if ( !$data->{ip_mask} && $data->{ip_masklen} )
	{
		$c->log->info("Add mask for network");
		$net = NetAddr::IP->new($data->{ip_network} . '/' . $data->{ip_masklen});
		$data->{ip_mask} = $net->mask();
	} elsif ( $data->{ip_mask} && !$data->{ip_masklen} ) {
		$c->log->info("Calculating mask length");
		$net = NetAddr::IP->new($data->{ip_network}, $data->{ip_mask});
		$data->{ip_masklen} = $net->masklen();
		
	}
	
	if ( $data->{active} eq 'Yes' ) { $data->{active} = 1; } else { $data->{active} = 0; }
	
	$c->model('CMDBv1::IpDomainNetwork')->update_or_create( $data );
	$c->log->debug(Dumper($data));
	
	$c->response->status(200);
	$c->response->body('');
}

sub del :Local {
	my($self, $c) = @_;
	my($row, $network_id);
	
	$network_id = int($c->request->params->{'id'});
	$row = $c->model('CMDBv1::IpDomainNetwork')->find({ network_id => $network_id });
	if ( defined($row) ) {
		$row->delete;
	}
	$c->response->status(200);
	$c->response->body('');
}

=head1 AUTHOR

Theo Bot

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;