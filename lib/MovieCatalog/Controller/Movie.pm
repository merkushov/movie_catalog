package MovieCatalog::Controller::Movie;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MovieCatalog::Controller::Movie - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub movie_item_chain :PathPart('movie') :Chained('/') :CaptureArgs(1) {
    my ( $self, $c, $movie_id ) = @_;

    $c->stash(
        movie => $c->model('DB::Movie')->search_rs(
            {
                'me.id' => $movie_id,
            },
            {
                prefetch => { movie_genres => 'genre' },
            }
        )->first
    );
}

=head2 view

=cut

sub view :Chained('movie_item_chain') :PathPart('view') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( template => 'movie/view.tt' );
}

=head2 list

=cut

sub list :Local :Args(0) {
    my ( $self, $c ) = @_;

    my $page = $c->req->param('p') || 1;

    $c->stash( 
        template => 'movie/list.tt',
        movies => $c->model('DB::Movie')->search_rs(
            undef,
            {
                prefetch => { movie_genres => 'genre' },
                order_by => { -desc => ['me.start_year','me.ctime'] },
                page => $page,
                rows => 10,
            }
        ),
    );

    $c->stash->{pager} = $c->stash->{movies}->pager;
}

sub add :GET :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        template    => 'movie/add.tt',
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

=head2 edit

=cut

sub edit :GET :Chained('movie_item_chain') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;

    my %genres = ();
    for ( $c->stash->{movie}->genres ) {
        $genres{ 'genre_' . $_->id } = 1;
    }

    $c->stash(
        template    => 'movie/edit.tt',
        genres      => $c->model('DB::Genre')->search_rs,
        params      => {
            runtime => $c->stash->{movie}->runtime,
            %genres,
        }
    );
}

sub edit_POST :POST :Chained('movie_item_chain') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;

    $c->stash->{movie}->update(
        {
            # title       => $params->{title},
            # start_year  => $params->{year},
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

    if ( scalar @genre_ids ) {
        my @genres = $c->model('DB::Genre')->search(
            { id => { '-in' => \@genre_ids } });

        $c->stash->{movie}->set_genres( \@genres );
    }

    $c->res->redirect( $c->uri_for( $self->action_for('view'), [ $c->stash->{movie}->id ] ) );
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
