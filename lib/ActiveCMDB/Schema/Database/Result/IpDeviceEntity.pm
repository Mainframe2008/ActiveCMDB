use utf8;
package ActiveCMDB::Schema::Database::Result::IpDeviceEntity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ActiveCMDB::Schema::Database::Result::IpDeviceEntity

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

=head1 TABLE: C<ip_device_entity>

=cut

__PACKAGE__->table("ip_device_entity");

=head1 ACCESSORS

=head2 device_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 entphysicalindex

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 entphysicalclass

  data_type: 'smallint'
  is_nullable: 1

=head2 entphysicalcontainedin

  data_type: 'integer'
  is_nullable: 1

=head2 entphysicaldescr

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 entphysicalname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 entphysicalserialnum

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 entphysicalhardwarerev

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 entphysicalfirmwarerev

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 entphysicalsoftwarerev

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 entphysicalvendortype

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 ifindex

  data_type: 'integer'
  is_nullable: 1

=head2 last_update

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "device_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "entphysicalindex",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "entphysicalclass",
  { data_type => "smallint", is_nullable => 1 },
  "entphysicalcontainedin",
  { data_type => "integer", is_nullable => 1 },
  "entphysicaldescr",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "entphysicalname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "entphysicalserialnum",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "entphysicalhardwarerev",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "entphysicalfirmwarerev",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "entphysicalsoftwarerev",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "entphysicalvendortype",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "ifindex",
  { data_type => "integer", is_nullable => 1 },
  "last_update",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</device_id>

=item * L</entphysicalindex>

=back

=cut

__PACKAGE__->set_primary_key("device_id", "entphysicalindex");

=head1 RELATIONS

=head2 device

Type: belongs_to

Related object: L<ActiveCMDB::Schema::Database::Result::IpDevice>

=cut

__PACKAGE__->belongs_to(
  "device",
  "ActiveCMDB::Schema::Database::Result::IpDevice",
  { device_id => "device_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-17 15:21:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+y55FxyomBqAaGf/rj1BCQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
