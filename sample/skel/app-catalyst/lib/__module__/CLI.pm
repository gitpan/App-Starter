package [* module *]::CLI;

use strict;
use warnings;

use base qw/Class::Accessor/;
use Catalyst::Utils;
use Config::Any;
use DirHandle;
use [* module *]::Schema;
use FindBin;
use File::Spec;

__PACKAGE__->mk_accessors(qw/config schema/);

sub new {
    my $class = shift;
    my $self = {};
    bless $self , $class;
    $self->load;
    return $self;
}

sub config_path {
    File::Spec->catfile( $FindBin::Bin , '../conf' );
}
sub app_name {
    '[* module *]::Web';
}

sub load {
    my $self = shift;
    $self->{config} = $self->load_config;

    $self->{schema}  = [* module *]::Schema->connect( @{ $self->{config}{'Model::DB'}{'connect_info'} } );
}

sub load_config {
    my $self = shift;
    my $files = $self->find_files;
    my $cfg   = Config::Any->load_files(
        {   files       => $files,
            use_ext     => 1,
        }
    );

    my $config = {};
    my $config_local = {};
    my $local_file = $self->local_file;
    for ( @$cfg ) {
        if ( ( keys %$_ )[ 0 ] eq $local_file ) {
            $config_local =  $_->{ (keys %{$_})[0] };
        }
        else {
            $config = {
                 %{ $_->{ (keys %{$_})[0] }},
                %{$config} , 
            }
        }
    }

    $config = {
        %{$config},
        %{$config_local} ,
    };
    return $config;
}

sub local_file {
    my $self = shift;
    my $prefix = Catalyst::Utils::appprefix( $self->app_name );
    return $self->config_path . '/'.  $prefix . '_local.yml';
}
sub find_files {
    my $self = shift;
    my $path = $self->config_path;
    my $extension = 'yml';
    my $prefix = Catalyst::Utils::appprefix( $self->app_name );

    my @files;
    push @files , "$path/$prefix.$extension";
   my $dh = DirHandle->new( $path );

    while ( my $file = $dh->read() ) {
        if ( $file =~ /^$prefix\_(\w+)\.$extension$/  ) {
            push @files , "$path/$file";
        }
    }

    return \@files;
}

1;
