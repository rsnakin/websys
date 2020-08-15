use strict;
use vars qw($defs);

$defs->{import} = {
  pattern => qr/^\s*([^\s]+)(?:\s+from\s+([\w:]+))?(?:\s+as\s+\$?([^\s]+))?(?:\s+(.+?))?\s*$/o,
  single  => 1,
  handler => \&import,
  version => 1.0,
};

sub import {
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my ($sub, $pkg, $as, $query) = @{$self->{params}};

  my $t = $self->{template};
  $pkg ||= $t->{pkg}->_name;

  $t->add_to_top("require FWork::System::Sub;");
  my $compiled = 'my $sub=FWork::System::Sub->new(name=>'.FWork::System::Utils::quote($sub).', pkg => $system->pkg('.FWork::System::Utils::quote($pkg).'), vars => $v);';

  my $name = (defined $as ? $as : $sub);

  $compiled .= '$v->{'.FWork::System::Utils::quote($name).'}=$sub->execute';
  if (true($query)) {
    $compiled .= '('.$t->compile(template => $query, tag_start => '<', tag_end => '>', raw => 1).')';
  }
  $compiled .= ';';

  $t->add_to_compiled($compiled);
}

1;