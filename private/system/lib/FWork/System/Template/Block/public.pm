use strict;
use vars qw($defs);

$defs->{public} = {
  pattern => qr/^\s*([^\s]+)(?:\s+from\s+(\S+?))?(?:\s+using\s+(\S+?))?\s*$/o,
  single  => 1,
  handler => \&public,
  version => 1.0,
};

use FWork::System::Utils qw(&quote);

sub public {
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $t = $self->{template};

  my $f_path = $self->{params}->[0];
  return if not $f_path;
  
  my $pkg_name = $self->{params}->[1]; # optional
  $pkg_name = $t->{pkg}->_name if false($pkg_name);
  
  my $skin_id = $self->{params}->[2]; # optional
  $skin_id = $t->{skin}->id if false($skin_id);
  
  $f_path = $skin_id.'/'.$f_path;
  
  my $query = '?pkg=system&action=public&f_path='.$f_path.'&f_pkg='.$pkg_name;
  
  $t->add_to_compiled('push @p,$system->config->get(\'cgi_url\').'.quote($query).';');
}

1;