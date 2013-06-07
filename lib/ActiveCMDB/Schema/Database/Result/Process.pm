use utf8;
package ActiveCMDB::Schema::Database::Result::Process;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ActiveCMDB::Schema::Database::Result::Process

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<process>

=cut

__PACKAGE__->table("process");

=head1 ACCESSORS

=head2 process_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 process_name

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 process_server

  data_type: 'integer'
  is_nullable: 1

=head2 process_status

  data_type: 'integer'
  is_nullable: 1

=head2 process_pid

  data_type: 'integer'
  is_nullable: 1

=head2 process_type

  data_type: 'integer'
  is_nullable: 1

=head2 process_path

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 process_comms

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 process_order

  data_type: 'integer'
  is_nullable: 1

=head2 process_update

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "process_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "process_name",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "process_server",
  { data_type => "integer", is_nullable => 1 },
  "process_status",
  { data_type => "integer", is_nullable => 1 },
  "process_pid",
  { data_type => "integer", is_nullable => 1 },
  "process_type",
  { data_type => "integer", is_nullable => 1 },
  "process_path",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "process_comms",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "process_order",
  { data_type => "integer", is_nullable => 1 },
  "process_update",
  { data_type => "bigint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</process_id>

=back

=cut

__PACKAGE__->set_primary_key("process_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<process_name_UNIQUE>

=over 4

=item * L</process_name>

=back

=cut

__PACKAGE__->add_unique_constraint("process_name_UNIQUE", ["process_name"]);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-17 15:21:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dgiG9yXwOeFIckU3zU6Q+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
