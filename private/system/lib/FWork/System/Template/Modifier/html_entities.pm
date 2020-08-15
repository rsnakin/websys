use strict;
use vars qw($defs);

$defs->{html_entities} = { 
  handler => \&html_entities,
  version => 1.0,
};

sub html_entities {
  my ($self, $var) = @_;
  return '' if false($var);
  return "FWork::System::Utils::html_entities($var)";
}

1;