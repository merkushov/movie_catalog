use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MovieCatalog';
use MovieCatalog::Controller::Movie;

ok( request('/movie')->is_success, 'Request should succeed' );
done_testing();
