use strict;
use vars qw($defs);

$defs->{session} = {
  pattern => qr/^session\.(?:(get)\.)?(.+)$/o,
  handler => \&session,
  version => 1.0,
};

sub session { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my ($get, $var) = @{$self->{params}};
  my $result;
  if (not $get) {
    $result = ($var =~ /^id|id_for_url$/ ? "\$system->session->$var" : '');
  } else {
    $result = '$system->session->get('.FWork::System::Utils::quote($var).')';
  }
  return $self->optimize($result);
}

1;