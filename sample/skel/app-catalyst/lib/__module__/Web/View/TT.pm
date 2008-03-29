package [* module *]::Web::View::TT;

use strict;
use base 'Catalyst::View::TT::Filters::LazyLoader';
use Path::Class;
use Template::Provider::Encoding;
use Template::Stash::ForceUTF8;

my $root = [* module *]::Web->config()->{root}->stringify;
my $common = Path::Class::dir( $root, 'common' )->stringify;

__PACKAGE__->config(
    FILTERS_LAZYLOADER => {
        lib_path =>  [* module *]::Web->path_to('lib'),
        pkg => '[* module *]::Web::TTFilters',
    },
    TEMPLATE_EXTENSION => '.tt',
    LOAD_TEMPLATES     => [
        Template::Provider::Encoding->new( INCLUDE_PATH => $root ),
        Template::Provider::Encoding->new( INCLUDE_PATH => $common ),
    ],
    STASH      => Template::Stash::ForceUTF8->new,
    PREFIX_MAP => {
        default => 0,
        common  => 1,
    },
);

sub process {
    my ( $self, $c ) = @_;

    unless ( $c->res->content_type ) {
        my $agent = $c->req->user_agent || '';
        $c->res->content_type(
            $agent =~ /MSIE/
            ? 'text/html; charset=utf-8'
            : 'application/xhtml+xml; charset=utf-8'
        );
    }
    $self->SUPER::process($c);
}

1;

