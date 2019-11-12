use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MovieCatalog';
use MovieCatalog::Controller::Analytics;

ok( request('/analytics')->is_success, 'Request should succeed' );
done_testing();
