use strict;
use vars qw($defs);

$defs->{error} = {
  pattern => qr/^error\.([^\.]+)(?:\.([^\.]+))?$/o,  
  handler => \&error,
  version => 1.0,
};

use FWork::System::Utils qw(&quote);

sub error { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my $err_num = $self->{params}->[0];
  my $err_method = $self->{params}->[1];

  my $compiled = '$system->error->get_error('.quote($err_num).')';
  if (true($err_method)) {
    $compiled .= '->'.$err_method;
  }
  
  return $self->optimize($compiled);
}

1;