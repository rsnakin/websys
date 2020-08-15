use strict;

use Stuffed::System;
use vars qw($defs);

$defs->{cut} = { 
  handler => \&cut,
  version => 1.0,
};

sub cut {
  my ($self, $var) = @_;
  return '' if false($var);

  my $length = $self->{param} =~ /^\d+$/ ?  $self->{param} : '';
  return "Stuffed::System::Utils::cut_string($var, $length)";
}

1;