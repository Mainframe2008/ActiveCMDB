package ActiveCMDB::Controller::Journal;

=begin nd

    Script: ActiveCMDB::Controller::Journal.pm
    ___________________________________________________________________________

    Version 1.0

    Copyright (C) 2011-2015 Theo Bot

    http://www.activecmdb.org


    Topic: Purpose

    Manage device journal

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

	Topic: Description
	
	This module performs actions on the conversions table
	
	
=cut

#########################################################################
# Initialize  modules

use Moose;
use namespace::autoclean;
use POSIX;
use DateTime;
use Data::Dumper;
use ActiveCMDB::Common::Security;

BEGIN { extends 'Catalyst::Controller'; }

sub api :Local {
	my($self, $c) = @_;
	
	if ( cmdb_check_role($c,qw/deviceViewer deviceAdmin/) )
	{
		if ( defined($c->request->params->{oper}) ) {
			$c->forward('/journal/' . $c->request->params->{oper});
		}
	} else {
		$c->response->redirect($c->uri_for($c->controller('Root')->action_for('noauth')));
	}
}

sub list :Local {
	my($self, $c) = @_;
	
	if ( cmdb_check_role($c,qw/deviceViewer deviceAdmin/) )
	{
		my($rs, $json);
		my @rows = ();
	
		my $rows	= $c->request->params->{rows} || 10;
		my $page	= $c->request->params->{page} || 1;
		my $order	= $c->request->params->{sidx} || 'journal_date';
		my $asc		= '-' . $c->request->params->{sord};
	
		$rs = $c->model("CMDBv1::IpDeviceJournal")->search(
					{
						device_id	=> $c->request->params->{device_id},
					},
					{
						rows		=> $rows,
						page		=> $page,
						order_by	=> { $asc => $order },
					}
			);
	
		$json->{records} = $rs->count;
		if ( $json->{records} > 0 ) {
			$json->{total} = ceil($json->{records} / $c->request->params->{rows} );
		} else {
			$json->{total} = 0;
		} 
	
		while ( my $row = $rs->next )
		{
			my $date = sprintf("%s", $row->journal_date);
			$date =~ s/T/ /;
			push(@rows, { id => $row->journal_id, cell=> [
															$date,
															$row->user,
															$row->journal_data
														]
						}
				);
		}
	
		$json->{rows} = [ @rows ];
		$c->stash->{json} = $json;
		$c->forward( $c->view('JSON') );
	} else {
		$c->response->redirect($c->uri_for($c->controller('Root')->action_for('noauth')));
	}
}

sub add :Local {
	my($self, $c) = @_;
	
	if ( cmdb_check_role($c,qw/deviceViewer deviceAdmin/) )
	{
		my $data = undef;
		if ( defined($c->request->params->{journal_data}) && length($c->request->params->{journal_data}) > 2 )
		{
			my $journal = ActiveCMDB::Object::Journal->new(device_id => $c->request->params->{device_id});
			$journal->data($c->request->params->{journal_data});
			$journal->prio(5);
			$journal->user($c->user->get('username'));
			$journal->date(DateTime->now());
			$journal->save();
		}
	
		$c->response->status(200);
		$c->response->body('');
	} else {
		$c->response->status(401);
		$c->response->body('');
	}
}

sub edit :Local {
	my($self, $c) = @_;
	
	if ( cmdb_check_role($c,qw/deviceViewer deviceAdmin/) )
	{
		my $data = undef;
		if ( defined($c->request->params->{journal_data}) && length($c->request->params->{journal_data}) > 2  )
		{
			my $journal = ActiveCMDB::Object::Journal->new(
								device_id 	=> $c->request->params->{device_id},
								journal_id	=> $c->request->params->{id}
							);
			$journal->get_data();
			$journal->data($c->request->params->{journal_data});
			$journal->save();
		}
	} else {
		$c->response->redirect($c->uri_for($c->controller('Root')->action_for('noauth')));
	}
}

__PACKAGE__->meta->make_immutable;

1;
