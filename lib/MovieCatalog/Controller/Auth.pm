package MovieCatalog::Controller::Auth;
use Moose;
use namespace::autoclean;
# use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MovieCatalog::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 signin

=cut

sub signin :GET :Path('/signin') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( template => 'auth/signin.tt' );
}

=head2 signin_POST

=cut

sub signin_POST :POST :Path('/signin') :Args(0) {
    my ( $self, $c ) = @_;

    my $username = $c->req->param('username');
    my $password = $c->req->param('password');

    $c->log->info("Attempt to login user '$username'");

    if ( $c->authenticate( { username => $username, password => $password} ) ) {
        $c->log->info("Authorization was successful");
        $c->res->redirect('/');
    } else {
        $c->log->info("Failed to sign in");
        $c->stash(
            signin_error_msg => 'Authorisation Error. '
                . 'Invalid username or password'
        );
        $c->forward( 'signin' );
    }
}

=head2 signout

=cut

sub signout :Path('/signout') :Args(0) {
    my ( $self, $c ) = @_;

    if ( $c->user_exists ) {
        $c->logout;
    }

    $c->res->redirect( $c->req->referer || '/' );
}


=encoding utf8

=head1 AUTHOR

Victor Merkushov,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
