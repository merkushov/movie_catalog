package MovieCatalog::Controller::Movie;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MovieCatalog::Controller::Movie - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 list

=cut

sub list :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( 
        template => 'movie/list.tt',
        movies => $c->model('DB::Movie')->search_rs(
            undef,
            {
                prefetch => { movie_genres => 'genre' },
            }
        ),
    );
}

sub add :GET :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        template => 'movie/add.tt',
        genres      => $c->model('DB::Genre')->search_rs,
    );

    # $Data::Dumper::Maxdepth = 2;
    # $c->log->debug( Dumper($c->stash) );
}

sub add_POST :POST :Path('add') :Args(0) {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;

    # $c->log->debug( Dumper($params) );

    if ( $params->{title} && $params->{year} ) {
        
        my $movie = $c->model('DB::Movie')->create(
            {
                title       => $params->{title},
                start_year  => $params->{year},
                (
                    $params->{runtime}
                        ? ( runtime => $params->{runtime} )
                        : ()
                ),
            });

        my @genre_ids = ();
        for my $key ( keys %{$params} ) {
            push @genre_ids, $1 if $key =~ m/^genre_(\d+)/;
        }

        my @genres = $c->model('DB::Genre')->search(
            { id => { '-in' => \@genre_ids } });

        # $Data::Dumper::Maxdepth = 3;
        # $c->log->debug( Dumper( \@genres ) );

        $movie->set_genres( \@genres, {} );

        $c->res->redirect('list');
    }
    else {
        $c->flash(
            error_msg => 'Fields "Title" and "Year" are required',
            params => $params,
        );
        $c->res->redirect( 'add' );
    }
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
