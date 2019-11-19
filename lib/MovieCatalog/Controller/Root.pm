package MovieCatalog::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

MovieCatalog::Controller::Root - Root Controller for MovieCatalog

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        template => 'index.tt',
        last_movies => $c->model('DB::Movie')->search_rs(
            undef,
            {
                prefetch => { movie_genres => 'genre' },
                order_by => { -desc => 'me.ctime' },
                rows => 3,
            }),
    );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;

    if ( $c->req->path =~ m/^admin/ ) {
        $c->forward( $c->view('TTAdmin') );
    }
    else {
        $c->forward( $c->view('TT') );
    }
}

=head1 AUTHOR

Victor Merkushov,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
