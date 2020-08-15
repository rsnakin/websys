use strict;
use vars qw($defs);

$defs->{encode_url} = { 
  handler => \&encode_url,
  version => 1.0,
};

sub encode_url {
  my ($self, $var) = @_;
  return '' if false($var);
  return "FWork::System::Utils::encode_url($var)";
}

1;