use strict;
use warnings;
use Test::More;

use lib 'lib';
use MovieCatalog;

our $TEST_TITLE = 'autotest';
our $TEST_YEAR  = 9999;

my $app = MovieCatalog->new();

$app->model('DB')->schema->storage->txn_do(sub {

    my $movie = $app->model('DB::Movie')->create(
        {
            title => $TEST_TITLE,
            start_year => $TEST_YEAR,
        });

    ok $movie, "Object was created";

    ok $app->model('DB::Movie')->search(
        {
            title => $TEST_TITLE,
            start_year => $TEST_YEAR
        })->first,
        "The record is presented in the database";

    $movie->set_genres( [{ id => 1 }] );

    ok $app->model('DB::MovieGenre')->search({ movie_id => $movie->id })->count,
        "Found 1 record in the 'movie_genders' bundle table";

    $app->model('DB')->schema->storage->txn_rollback();
});

done_testing();