package MovieCatalog::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

use MovieCatalog::AppConfig;

__PACKAGE__->config(
    schema_class => 'MovieCatalog::Schema',
    connect_info => MovieCatalog::AppConfig->new->db_connect_info,
);

=head1 NAME

MovieCatalog::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<MovieCatalog>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<MovieCatalog::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.54

=head1 AUTHOR

Victor Merkushov

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
