use strict;
use vars qw($defs);

$defs->{properties} = {
  pattern => qr/^properties(?:\.(.+?))?\.([^\.]+)$/o,
  handler => \&properties,
  version => 1.0,
};

sub properties { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my $t = $self->{template};
  my ($pkg, $var) = @{$self->{params}};
  $pkg =~ s/\./:/g if true($pkg);

  my $result;

  if (true($pkg) and $pkg ne $t->{pkg}->_name) {
    $result = '$system->pkg('.FWork::System::Utils::quote($pkg).')->_properties('.FWork::System::Utils::quote($var).')';
  } else {
    $result = '$s->{pkg}->_properties('.FWork::System::Utils::quote($var).')';
  }

  return $self->optimize($result);
}


1;