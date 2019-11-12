package MovieCatalog::Schema;
 
use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces();
 
our $VERSION = 2;
 
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
 
1;