package MovieCatalog::Schema::Result::Movie;
 
use strict;
use warnings;
 
use base 'DBIx::Class::Core';
 
__PACKAGE__->table('movies');
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0
    },
    'title' => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0
    },
    'start_year' => {
        data_type => 'smallint'
    },
    'runtime' => {
        data_type => 'smallint',
        is_nullable => 1,
    },
    'imdb_id' => {
        data_type => 'varchar',
        size => 30,
        is_nullable => 1,
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
__PACKAGE__->add_unique_constraint('movies_imdb_id_uidx', ['imdb_id']);

__PACKAGE__->has_many(
  'movie_genres',
  'MovieCatalog::Schema::Result::MovieGenre',
  { 'foreign.movie_id' => 'self.id' },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many( genres => 'movie_genres', 'genre' );

sub get_genres_names {
    my $self = shift;

    my @names = ();
    for ( $self->genres ) {
        push @names, $_->name;
    }

    return \@names;
}

1;