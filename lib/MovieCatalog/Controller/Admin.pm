package MovieCatalog::Controller::Admin;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config( namespace => '' );

=encoding utf-8

=head1 NAME

MovieCatalog::Controller::Admin - Admin Controller for MovieCatalog

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 admin_chain

Base admin chain

=cut

sub admin_chain :Chained('/') :PathPart('admin') :CaptureArgs(0)  {
    my ( $self, $c ) = @_;

    $c->detach('/e403')
        unless $c->check_user_roles(qw/ admin /);
}

=head2 index

Admin interface home page (/admin)

=cut

sub index :Chained('admin_chain') :PathPrefix :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        template => 'admin/index.tt',
        wrapper => ''
    );
}

=head2 e403

403 admin error page

=cut

sub e403 :Private {
    my ( $self, $c ) = @_;
    $c->res->status(403);
    $c->res->body("403<br />");
}

=head1 AUTHOR

Victor Merkushov,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
