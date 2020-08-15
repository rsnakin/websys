use strict;
use vars qw($defs);

use FWork::System;

$defs->{quote_single_quotes} = { 
  handler => \&quote_single_quotes,
  version => 1.0,
};

sub quote_single_quotes {
  my ($self, $var) = @_;
  
  return '' if false($var);
  return "FWork::System::Utils::quote($var, q('), undef, 1)";
}

1;