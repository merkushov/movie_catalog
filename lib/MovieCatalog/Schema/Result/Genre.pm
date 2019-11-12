package MovieCatalog::Schema::Result::Genre;
 
use strict;
use warnings;
 
use base 'DBIx::Class::Core';
 
__PACKAGE__->table('genres');
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0
    },
    'name' => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0
    },
    'ctime' => {
        data_type     => 'timestamp',
        default_value => \'current_timestamp',
        is_nullable   => 0,
        locale        => 'ru_RU',
        original      => { default_value => \'now()' },
    },
);
 
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
  'movie_genres',
  'MovieCatalog::Schema::Result::MovieGenre',
  { 'foreign.genre_id' => 'self.id' },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many( movies => 'movie_genres', 'movie' );
 
1;