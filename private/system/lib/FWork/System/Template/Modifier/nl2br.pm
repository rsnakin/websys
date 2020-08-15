use strict;
use vars qw($defs);

$defs->{nl2br} = { 
  handler => \&nl2br,
  version => 1.0,
};

sub nl2br {
  my ($self, $var) = @_;
  return '' if false($var);
  return "FWork::System::Utils::nl2br($var)";
}

1;