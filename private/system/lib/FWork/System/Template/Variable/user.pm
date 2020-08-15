use strict;
use vars qw($defs);

$defs->{user} = {
  pattern => qr/^user(?:\.(.+?))?\.([^\.]+)$/o,
  handler => \&user,
  version => 1.0,
};

sub user {
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my ($pkg, $var) = @{$self->{params}};
  $pkg = $self->{template}->{pkg}->_name if false($pkg);
  
  my $result;

  if ($var eq 'logged') {
    $result = '$system->user->logged';
  } else {
    $result = '$system->user->profile('.FWork::System::Utils::quote($var);
    $result .= ',pkg=>'.FWork::System::Utils::quote($pkg) if $pkg ne 'system';
    $result .= ')';
  }

  return $self->optimize($result);
}

1;