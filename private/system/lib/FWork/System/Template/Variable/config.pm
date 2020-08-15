use strict;
use vars qw($defs);

$defs->{config} = {
  pattern => qr/^config(?:\.(.+?))?\.([^\.]+)$/o,
  handler => \&config,
  version => 1.0,
};

sub config { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my $t = $self->{template};
  my ($pkg, $var) = @{$self->{params}};
  $pkg =~ s/\./:/g if true($pkg);

  my $res_line;

  if (true($pkg) and $pkg ne $t->{pkg}->_name) {
    $res_line = '$system->pkg('.FWork::System::Utils::quote($pkg).')->_config->get('.FWork::System::Utils::quote($var).')';
  } else {
    $res_line = '$s->{pkg}->_config->get('.FWork::System::Utils::quote($var).')';
  }

  return $self->optimize($res_line);
}

1;