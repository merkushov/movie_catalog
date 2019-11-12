package MovieCatalog::Schema::Result::MovieGenre;
 
use strict;
use warnings;
 
use base 'DBIx::Class::Core';
 
__PACKAGE__->table('movie_genres');
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0
    },
    'movie_id' => {
        data_type => 'integer',
        is_nullable => 0
    },
    'genre_id' => {
        data_type => 'integer',
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
__PACKAGE__->add_unique_constraint(
  'movie_genres_movie_id_genre_id_ukey',
  ['movie_id','genre_id'],
);

__PACKAGE__->belongs_to(
  'movie',
  'MovieCatalog::Schema::Result::Movie',
  { id => 'movie_id' },
  { is_deferrable => 1, on_delete => 'CASCADE', on_update => 'CASCADE' },
);

__PACKAGE__->belongs_to(
  'genre',
  'MovieCatalog::Schema::Result::Genre',
  { id => 'genre_id' },
  { is_deferrable => 1, on_delete => 'CASCADE', on_update => 'CASCADE' },
);

1;