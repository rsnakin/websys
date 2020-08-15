use strict;
use vars qw($defs);

$defs->{text} = {
  pattern => qr/^text\.(.+)$/o,
  handler => \&text,
  version => 1.0,
};

sub text { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $var = $self->{params}->[0];
  return $self->optimize('$s->{text}->get('.FWork::System::Utils::quote($var).')');
}

1;