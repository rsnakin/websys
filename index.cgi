#!/usr/bin/perl
# This is a test
use strict;

# CGI::Carp will be initialized lower, just before the require of FWork::System
# Good: We will include our own CGI::Carp version from private/system/lib, which
#       doesn't output an extra content-type header.
# Bad: Until that point is reached in the execution all errors are not printed in 
#      the browser (for debugging such cases, the line below could be temporary
#      uncommented).

#use CGI::Carp qw(fatalsToBrowser);

require 5.005_03;

$| = 1;

# physical path of the folder where "private" folder is located, which
# contains "system" package;
# if it is undefined then we use the current folder from which this
# index.cgi file was launched (standard behaviour)
my $sys_path = undef;

# optional physical path of an additional packages folder, which in a 
# standard situation is equal to the $sys_path above;
# if it is undefined then we use the current folder from which this
# index.cgi file was launched (standard behaviour)
my $pkg_path = undef;

# calculating physical path to the current directory
if (not defined $pkg_path) {
  my $regexp = qr/^(.+)([\/\\])[^\2]+$/o;
  if ($ENV{DOCUMENT_ROOT}) {
    $pkg_path = $ENV{DOCUMENT_ROOT}.$ENV{SCRIPT_NAME} if -e $ENV{DOCUMENT_ROOT}.$ENV{SCRIPT_NAME};
    $pkg_path = $ENV{SCRIPT_FILENAME} if not defined $pkg_path;
    ($pkg_path) = $pkg_path =~ /$regexp/; 
  }
  ($pkg_path) = $0 =~ /$regexp/ if not defined $pkg_path or $pkg_path eq '';
  if (not defined $pkg_path or $pkg_path eq '' or not -e $pkg_path) {
    $pkg_path = '.';
  } else {
    $pkg_path =~ s/\\/\//g;
  }
}

# if system path was not specified, then it becomes equal to the 
# packages path
$sys_path = $pkg_path if not defined $sys_path;

unshift @INC, $pkg_path, "$sys_path/private/system/lib";

# doing this here to load our own version of CGI::Carp from the FWork System's 
# lib directory (it doesn't output extra content-type header, which is important
# for us because our die handler does this on its own)
require CGI::Carp;
CGI::Carp->import('fatalsToBrowser');


require FWork::System;
#print "Content-type: text/html\n\nHello<br>$sys_path<br>$pkg_path";
#__END__
my $system = FWork::System->new($sys_path, $pkg_path);
$system->run->stop;


1;