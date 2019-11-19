package MovieCatalog::View::TTAdmin;

use base 'MovieCatalog::View::TT';

=head1 NAME

MovieCatalog::View::TTAdmin - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=cut

__PACKAGE__->config(
    WRAPPER => '_common/wrapper_admin.tt',
);

=head1 AUTHOR

Victor Merkushov

=cut

1;
