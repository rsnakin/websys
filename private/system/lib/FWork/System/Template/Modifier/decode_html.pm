use strict;
use vars qw($defs);

$defs->{decode_html} = { 
  handler => \&decode_html,
  version => 1.0,
};

sub decode_html {
  my ($self, $var) = @_;
  return '' if false($var);
  return "FWork::System::Utils::decode_html($var)";
}

1;