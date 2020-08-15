use strict;
use vars qw($defs);

$defs->{language} = {
  pattern => qr/^language\.(.+)$/o,
  handler => \&language,
  version => 1.0,
};

sub language { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $var = $self->{params}->[0];
  return $self->optimize('$s->{language}->config->get('.FWork::System::Utils::quote($var).')');
}

1;