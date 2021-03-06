use utf8;
package ActiveCMDB::Schema::Database::Result::IpDomain;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ActiveCMDB::Schema::Database::Result::IpDomain

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

=head1 TABLE: C<ip_domain>

=cut

__PACKAGE__->table("ip_domain");

=head1 ACCESSORS

=head2 domain_id

  data_type: 'integer'
  is_nullable: 0

=head2 domain_name

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 active

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "domain_id",
  { data_type => "integer", is_nullable => 0 },
  "domain_name",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "active",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</domain_id>

=back

=cut

__PACKAGE__->set_primary_key("domain_id");

=head1 RELATIONS

=head2 ip_domain_networks

Type: has_many

Related object: L<ActiveCMDB::Schema::Database::Result::IpDomainNetwork>

=cut

__PACKAGE__->has_many(
  "ip_domain_networks",
  "ActiveCMDB::Schema::Database::Result::IpDomainNetwork",
  { "foreign.domain_id" => "self.domain_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-17 15:21:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dighcJ1rytm76oP3726NTw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
