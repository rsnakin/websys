use strict;
use vars qw($defs);

$defs->{encode_html} = { 
  handler => \&encode_html,
  version => 1.0,
};

sub encode_html {
  my ($self, $var) = @_;
  return '' if false($var);
  return "FWork::System::Utils::encode_html($var)";
}

1;