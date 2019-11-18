package MovieCatalog::AppConfig;

use Moose;
use namespace::autoclean;
use Data::Dumper;
use Config::Any;

=head1 NAME

MovieCatalog::AppConfig

=head1 ACCESSORS

=head2 config

=cut

has config => (
    is  => 'rw',
    isa => 'HashRef',
    default => sub{{}}
);

sub BUILD {
    my $self = shift;

    my $cfg = Config::Any->load_files(
        {
            use_ext => 1,
            files => [ './moviecatalog.conf' ]
        });

    my %config = ();
    for ( @{$cfg} ) {
        my ( $filename, $data ) = %$_;
        %config = ( %config, %{$data} );
    }

    return $self->config( \%config );
}

sub db_connect_info { shift->config->{'Model::DB'}{connect_info} }

__PACKAGE__->meta->make_immutable;

1;
