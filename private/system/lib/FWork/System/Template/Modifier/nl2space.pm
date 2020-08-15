use strict;
use vars qw($defs);

$defs->{nl2space} = { 
  handler => \&nl2space,
  version => 1.0,
};

sub nl2space {
  my ($self, $var) = @_;
  return '' if false($var);
  return "FWork::System::Utils::nl2space($var)";
}

1;