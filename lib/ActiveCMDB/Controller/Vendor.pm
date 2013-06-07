package ActiveCMDB::Controller::Vendor;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ActiveCMDB::Controller::Vendor - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Private {
    my ( $self, $c ) = @_;

	#
	# Get all vendors for schema
	#
	$c->stash->{vendors} = [ $c->model('CMDBv1::Vendor')->all ];
	
	#
	# Add admin flag to template
	#
	if ( $c->check_user_roles('vendorAdmin') )
	{
		$c->stash->{admin} = 1;
	} else {
		$c->stash->{admin} = 0;
	} 
    #
    # Add proper template
    #
    $c->stash->{template} = 'vendor/list.tt';
}

sub view :Local {
	my( $self, $c ) = @_;
	
	#
	# Get vendor data
	#
	my $id = $c->request->params->{vendor};
	$c->stash->{vendor} = $c->model('CMDBv1::Vendor')->find({ vendor_id => $id} );
	
	if ( $c->check_user_roles('vendorAdmin') )
	{
		$c->stash->{template} = 'vendor/edit.tt';
	} else {
		if ( $id > 0 ) {
			$c->stash->{template} = 'vendor/view.tt';
		}
	}
	
}

sub save :Local {
	my( $self, $c ) = @_;
	my($data);
	
	if ( $c->check_user_roles('vendorAdmin') )
	{
		$data = undef;
		$data->{vendor_id}			  = $c->request->params->{id} || undef;
		$data->{vendor_name}		  = $c->request->params->{name} || "";
		$data->{vendor_phone}		  = $c->request->params->{salestel} || "";
		$data->{vendor_support_phone} = $c->request->params->{supporttel} || "";
		$data->{vendor_support_email} = $c->request->params->{supportmail} || "";
		$data->{vendor_support_www}	  = $c->request->params->{supportweb} || "";
		$data->{vendor_enterprises}	  = $c->request->params->{enterprise} || "";
		$data->{vendor_details}		  = $c->request->params->{details} || "";
		
		foreach my $key (keys %$data) {
			$data->{$key} =~ s/\'/\\\'/;
		}
		
		if ( !defined($data->{vendor_id}) && defined($data->{vendor_name}) )
		{
			my $count = $c->model('CMDBv1::Vendor')->search({ vendor_name => $data->{vendor_name} })->count;
			if ( $count > 0 )
			{
				$c->response->body('Vendor already exists');
				return;
			}
		}
		$c->log->debug(Dumper($data));
		
		try {
			$c->log->debug("Updating vendor");
			my $vendor = $c->model('CMDBv1::Vendor')->update_or_create( $data );
			if ( ! $vendor->in_storage ) {
				$vendor->insert;
			}
			
			$c->response->body('Vendor saved');
		} catch {
			$c->response->body("Failed to save ");
			$c->log->warn("Failed to save vendor ". $_);
		}
			
	} else {
		$c->response->redirect($c->uri_for($c->controller('Root')->action_for('noauth')));
	}
}

=head1 AUTHOR

Theo Bot

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;