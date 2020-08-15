use strict;
use vars qw($defs);

$defs->{pkg} = {
  pattern => qr/^pkg(?:\.(.+?))?\.([^\.]+)$/o,
  handler => \&pkg,
  version => 1.0,
};

sub pkg { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my $t = $self->{template};
  my ($pkg, $var) = @{$self->{params}};
  $pkg =~ s/\./:/g if true($pkg);

  if (true($pkg) and $pkg ne $t->{pkg}->_name) {
    $self->optimize('$system->pkg('.FWork::System::Utils::quote($pkg).')->_'.$var);
  } else {
    $self->optimize('$s->{pkg}->_'.$var);
  }
}

1;