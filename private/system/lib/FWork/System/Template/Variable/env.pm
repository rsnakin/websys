use strict;
use vars qw($defs);

$defs->{env} = {
  pattern => qr/^env\.(.+)$/o,
  handler => \&env,
  version => 1.0,
};

sub env { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $var = $self->{params}->[0];
  if ($var eq 'all') {
    return 'join("<br>\n", map {"$_ => $ENV{$_}"} sort keys %ENV)';
  } else {
    return '$ENV{'.FWork::System::Utils::quote(uc($var)).'}';
  }
}

1;