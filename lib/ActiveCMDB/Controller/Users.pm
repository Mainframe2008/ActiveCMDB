package ActiveCMDB::Controller::Users;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ActiveCMDB::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Private {
	my($self, $c) = @_;
	
	if ( $c->check_user_roles('admin') )
	{
		$c->log->info("Listing all users");
		$c->stash->{admin} = 1;
		$c->stash->{users} = [ $c->model('CMDBv1::User')->all ];
	} else {
		$c->log->info("Fetching current user");
		$c->stash->{admin} = 0;
		$c->stash->{users} = [ $c->model('CMDBv1::User')->find({ username => $c->user->username })   ];
	}
	
	
	$c->log->info("Found " . scalar(@{$c->stash->{users}}) . " objects");
	$c->stash->{template} = 'users/list.tt';
}

sub edit :Local {
	my($self, $c) = @_;
	my($user_id);
	
	$user_id = $c->request->params->{user_id} || 0;
	
	$c->stash->{user} = $c->model('CMDBv1::User')->find({ id => $user_id });
	
	if ( $c->check_user_roles('admin'))
	{
		my $rs = $c->model('CMDBv1::UserRole')->search({ user_id => $user_id });
		my @assigned  = ();
		my @available = ();
		my @h = ();
		while ( my $row = $rs->next )
		{
			push(@assigned, { id => $row->role_id, role => $row->role->role });
			push(@h, $row->role_id);
		}
		$rs = $c->model('CMDBv1::Role')->search({ id => { 'NOT IN' => [ @h ] } });
		while ( my $row = $rs->next )
		{
			push(@available, { id => $row->id, role => $row->role });
		}
		
		$c->stash->{available} = [ @available ];
		$c->stash->{assigned} = [ @assigned ];
		$c->stash->{template} = 'users/edit.tt';
	} else {
		$c->stash->{template} = 'users/passwd.tt';
	}
}

sub save :Local {
	my($self, $c) = @_;
	my @userRoles = ();
	my($user_id, $transaction, $row, $rs, $user);
	$c->log->info(Dumper($c->request->params));
	
	if ( defined($c->request->params->{userRoles}) )
	{
		if ( ref $c->request->params->{userRoles} eq 'ARRAY' )
		{
			foreach my $role (@{$c->request->params->{userRoles}})
			{
				push(@userRoles, int($role));
			} 
		} else {
			push(@userRoles, int($c->request->params->{userRoles}));
		}
	}
	
	#
	# Create transaction to save data
	#
	my $data = undef;
	$data->{id}				= $c->request->params->{id} || undef;
	$data->{username}		= $c->request->params->{username};
	$data->{active}			= $c->request->params->{active} || 0;
	$data->{email_address}	= $c->request->params->{email} || "";
	$data->{first_name}		= $c->request->params->{first_name} || "";
	$data->{last_name}		= $c->request->params->{last_name} || "";
	
	if ( ! defined($data->{id}) && defined($data->{username}) )
	{
		my $count = $c->model('CMDBv1::User')->search({ username => $data->{username}})->count;
		if ( $count > 0 ) 
		{
			$c->response->body("Username already in use");
			return;
		}
	}
	
	
	$transaction = sub {
		$user = $c->model('CMDBv1::User')->update_or_create($data);
		if ( ! $user->in_storage ) 
		{
			$user->insert;
			$c->log->debug("New user id:" . $user->id);
		} else {
			$user_id = $c->request->params->{id};
			$c->log->info("Updated user $user_id");
		}
		$user_id = $user->id;
		
		
		$user = $c->model('CMDBv1::User')->find({ username => $c->request->params->{username} });
		
		
		if ( defined($c->request->params->{newpass1}) && defined($c->request->params->{newpass2}) 
			&& $c->request->params->{newpass1} eq $c->request->params->{newpass2}
		) { 
			$user->password($c->request->params->{newpass1});
			$user->update;
		} else {
			$c->log->info("Password not updated");
		}
		
	};
	
	$c->model('CMDBv1')->txn_do($transaction);
	
	#
	# Create transaction to handle user roles
	#
	$transaction = sub {
		
		$rs = $c->model('CMDBv1::UserRole')->search(
					{
						user_id => $user_id,
						role_id => { 'NOT IN' => [ @userRoles ]}
					}
				);
		while ( $row = $rs->next ) {
			$row->delete;
		}
		
		foreach my $role ( @userRoles ) {
			my $data = { user_id => $user_id, role_id => $role };
			$c->model('CMDBv1::UserRole')->update_or_create($data);
		} 
	};
	
	# Execute transaction
	$c->model('CMDBv1')->txn_do($transaction);
	
	$c->response->body('User saved');
	
	
	
}

sub delete :Local {
	my($self, $c) = @_;
	my($user_id, $rs);
	$user_id = $c->request->params->{id} || 0;
	
	$rs = $c->model('CMDBv1::User')->find({ id => $user_id });
	
	if ( defined($rs) ) {
		$rs->delete;
	}
	
	$c->response->body('User deleted');
}

sub passwd :Local {
	my($self, $c) = @_;
	my($user, $current, $new1, $new2,$rs);
	
	$current = $c->request->params->{curpass};
	$new1	 = $c->request->params->{newpass1};
	$new2	 = $c->request->params->{newpass2};
	$user    = $c->user->username;
	
	$rs = $c->model('CMDBv1::User')->find({ username => $user });
	
	if ( defined($rs) )
	{
		if ( $rs->check_password($current) )
		{
			if ( $new1 eq $new2 )
			{
				$rs->password($new1);
				$rs->update;
				$c->response->body('Password updated');
			} else {
				$c->response->body("Passwords don\'t match");
			}
		} else {
			$c->response->body('Invalid user password');
		}
	} else {
		$c->response->body('User not found');
		$c->log->error("User $user not found");
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