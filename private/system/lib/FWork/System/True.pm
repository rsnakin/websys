package FWork::System::True;

$VERSION = 1.00;

use strict;
use vars qw(@ISA @EXPORT);

require Exporter; @ISA = qw(Exporter); @EXPORT = qw(true false);

sub true { 
 return if not @_;
 for (@_) {
   return if not defined $_ or $_ eq '';
 }
 return 1;
}
sub false { 
 return 1 if not @_;
 for (@_) {
   return if defined $_ and $_ ne '';
 }
 return 1;
}

1;

__END__

=head1 NAME

FWork::System::True - Alternative true and false implementation

=head1 SYNOPSIS

  use FWork::System::True;

  my $some_variable = 0;

  if (true($some_variable)) {
    # this block is executed, because 0 is true for us
  }

  $some_variable = '';

  if (false($some_variable)) {
    # this block is executed, because empty string is false for us
  }

=head1 DESCRIPTION

FWork::System::True implements an alternative view on what is true and false in
Perl. Perl itself thinks that true is a 'defined' value, not an empty string
and not a 0. This alternative implementation thinks that 0 is also true and
false is a value that is not defined or is an empty string.

The C<true> and C<false> functions are imported in the current package by
default.

=head1 AUTHOR

Sergey Smirnov, sergey@stuffedguys.com

=cut