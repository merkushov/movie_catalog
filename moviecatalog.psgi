use strict;
use warnings;

use MovieCatalog;

my $app = MovieCatalog->apply_default_middlewares(MovieCatalog->psgi_app);
$app;

