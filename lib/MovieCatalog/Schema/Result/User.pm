package MovieCatalog::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

__PACKAGE__->table("users");


__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "varchar", size => 255, is_nullable => 0 },
  "password",
  { data_type => "varchar", size => 255, is_nullable => 0 },
  "email_address",
  { data_type => "varchar", size => 500, is_nullable => 1 },
  "first_name",
  { data_type => "varchar", size => 255, is_nullable => 1 },
  "last_name",
  { data_type => "varchar", size => 255, is_nullable => 1 },
  "active",
  { data_type => "bool", is_nullable => 0, default => 1 },
  "birth_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  'ctime' => {
      data_type     => 'timestamp',
      default_value => \'current_timestamp',
      is_nullable   => 0,
      locale        => 'ru_RU',
      original      => { default_value => \'now()' },
  },
  'utime' => {
      data_type     => 'timestamp',
      default_value => \'current_timestamp',
      is_nullable   => 0,
      locale        => 'ru_RU',
      original      => { default_value => \'now()' },
  },
);

__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "user_roles",
  "MovieCatalog::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
