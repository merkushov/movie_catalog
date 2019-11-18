#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use File::Fetch;
use Getopt::Long;
use Log::Log4perl qw/:easy/;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use Text::CSV_XS;

use lib 'lib';
use MovieCatalog::Model::DB;

Log::Log4perl->easy_init($DEBUG);

my %opt = ();
GetOptions (\%opt, 'force');

our $TMP_PATH = '/tmp';

my $db = MovieCatalog::Model::DB->new;
my $csv = Text::CSV_XS->new (
    {
        binary => 1,
        auto_diag => 1,
        sep_char => "\t",
        quote => "SOMEUNMARKABLE"
    });

&process_movies();
# &process_ratings();

sub process_movies {

    my $file = fetch_file( 'https://datasets.imdbws.com/title.basics.tsv.gz');

    if ( -f $file ) {
        if ( open my $fh, "<", $file ) {

            INFO "Start processing the file";

            my $title = $csv->getline($fh);
            my @movies_insert   = ();
            # my @genre_insert    = ();
            my %unique_genres   = %{ &_get_genres_hash() };

            while ( my $row = $csv->getline($fh) ) {
                if ( $row->[1] eq 'movie' ) {

                    # DEBUG Dumper( $row );

                    my $start_year = $row->[5] && lc($row->[5]) ne '\n'
                        ? $row->[5]
                        : undef;
                    my $runtime = $row->[7] && lc($row->[7]) ne '\n'
                        ? $row->[7]
                        : undef;

                    next unless $start_year && $start_year >= 1990;

                    my @genres = ();
                    if ( $row->[8] ) {

                        my @genre_ids = ();
                        for my $genre ( map { lc } split(',', $row->[8]) ) {

                            next if $genre eq '\n';
                            if ( $unique_genres{$genre} ) {
                                push @genres, { genre_id => $unique_genres{$genre} };
                            }
                            else {
                                my $genre = $db->resultset('Genre')
                                    ->find_or_create({ name => $genre });
                                push @genres, { genre_id => $genre->id };
                                %unique_genres = %{ &_get_genres_hash() };
                            }
                        }

                    }

                    push @movies_insert, {
                        imdb_id     => $row->[0],
                        title       => $row->[2],
                        start_year  => $start_year,
                        runtime     => $runtime,
                        (
                            scalar( @genres )
                                ? ( movie_genres => \@genres )
                                : ()
                        )
                    };
                }

                if ( scalar( @movies_insert ) > 0 && scalar( @movies_insert ) % 3000 == 0 ) {
                    INFO "Insert 3000 rows into database";
                    $db->resultset('Movie')->populate( \@movies_insert );
                    @movies_insert = ();
                }

            }
            close $fh;
        }
        else {
            ERROR "$file: $!";
        }
    }
    else {
        ERROR "Can't find unzipped file";
    }

}

sub _get_genres_hash {
    return { map { $_->name => $_->id } $db->resultset('Genre')->all }
}

sub process_ratings {

    my $file = fetch_file( 'https://datasets.imdbws.com/title.ratings.tsv.gz');

    if ( -f $file ) {
        if ( open my $fh, "<:encoding(utf8)", $file ) {
            my $title = $csv->getline($fh);
            while ( my $row = $csv->getline($fh) ) {
                ERROR Dumper($row);
                last;
            }
            close $fh;
        }
        else {
            ERROR "$file: $!";
        }
    }
    else {
        ERROR "Can't find unzipped file";
    }
}

sub fetch_file {
    my ( $url ) = @_;

    my ( $file_zip ) = ( $url ) =~ m!([^/]+)$!;
    
    my $file = $file_zip;
    $file =~ s/\.gz//;

    my $filepath_zip = $TMP_PATH . '/' . $file_zip;
    my $filepath     = $TMP_PATH . '/' . $file;

    if ( ! -f $filepath_zip && ! -f $filepath ) {
        my $ff = File::Fetch->new( uri => $url, file_default => $file_zip );

        INFO "Donwload '$file_zip' file...";

        $ff->fetch( to => $TMP_PATH ) or ERROR $ff->error;
    }

    if ( ! -f $filepath && -f $filepath_zip ) {
        INFO "Unzip '$file'...";

        if ( gunzip $filepath_zip => $filepath ) {
            unlink $filepath_zip;
        }
        else {
            ERROR "Can't unzip file '$file_zip': $GunzipError";
        }
    }

    return -f $filepath ? $filepath : undef;
}

exit(0);