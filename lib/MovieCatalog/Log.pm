package MovieCatalog::Log;

use base 'Log::Dispatch';
use Catalyst::Utils;

sub new {
    my $class = shift;

    my $env_debug = Catalyst::Utils::env_value( 'MovieCatalog', 'DEBUG' );

    my $log = $class->SUPER::new(
        outputs => [
            $env_debug 
                ? [ 'Screen', min_level => 'debug', newline => 1, stderr => 1 ]
                # : [ 'Syslog', min_level => 'error', ident => 'vkino_cron' ],
                : [ 'Screen', min_level => 'error', newline => 1, stderr => 1 ]
        ],
        @_,
    );
    return $log;
}

1;
