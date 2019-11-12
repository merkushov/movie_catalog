use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MovieCatalog';
use MovieCatalog::Controller::MyMovie;

ok( request('/mymovie')->is_success, 'Request should succeed' );
done_testing();
