use utf8;
package ActiveCMDB::Schema::Result::IpDeviceMac;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ActiveCMDB::Schema::Result::IpDeviceMac

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

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::EncodedColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 TABLE: C<ip_device_mac>

=cut

__PACKAGE__->table("ip_device_mac");

=head1 ACCESSORS

=head2 device_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 ifindex

  data_type: 'integer'
  is_nullable: 0

=head2 mac

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 disco

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "device_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "ifindex",
  { data_type => "integer", is_nullable => 0 },
  "mac",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "disco",
  { data_type => "bigint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</device_id>

=item * L</ifindex>

=item * L</mac>

=back

=cut

__PACKAGE__->set_primary_key("device_id", "ifindex", "mac");

=head1 RELATIONS

=head2 device

Type: belongs_to

Related object: L<ActiveCMDB::Schema::Result::IpDevice>

=cut

__PACKAGE__->belongs_to(
  "device",
  "ActiveCMDB::Schema::Result::IpDevice",
  { device_id => "device_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-10-30 14:31:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U7NWzrRyV6WDLQEemFbaog


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
