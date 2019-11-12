package MovieCatalog::View::TT;

use base 'Catalyst::View::TT';
use Template::Stash::XS;

=head1 NAME

MovieCatalog::View::TT - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=cut

__PACKAGE__->config(
    INCLUDE_PATH => [
        MovieCatalog->path_to( 'root', 'src' ),
    ],
    ENCODING    => 'utf-8',
    COMPILE_EXT => '.ttc',
    COMPILE_DIR => '/tmp',
    STASH       => Template::Stash::XS->new,
    WRAPPER     => 'wrapper.tt',
);

=head1 AUTHOR

Victor Merkushov

=cut

1;
