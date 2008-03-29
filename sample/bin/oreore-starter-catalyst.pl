#!/usr/bin/perl 

use strict;
use warnings;
use App::Starter;
use Getopt::Long;

my %opt;
GetOptions( \%opt, 'config=s' , 'name=s');
App::Starter->new( { config => $opt{config} , name => $opt{name} , replace => { module => $opt{name} , appprefix => lc $opt{name}  }  } )->create;

1;
__END__

=head1 NAME

app-starter-catalyst.pl - App::Starter script file.

=head1 SYNOPSYS

 app-starter-catalyst.pl --config conf/your-config.yml --name my_application

=head1 SEE ALSO

L<App::Starter>

=head1 AUTHOR

Tomohiro Teranishi

=cut



