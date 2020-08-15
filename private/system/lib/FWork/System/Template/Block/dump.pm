use strict;
use vars qw($defs);

$defs->{dump} = {
  pattern => qr/^\s*([^\s]+)\s*$/o,
  single  => 1,
  handler => \&dump,
  version => 1.1,
};

sub dump {
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $t = $self->{template};
  my $var = $self->{params}->[0];
  if ($var eq 'vars') {
    $var = '$v';
  } else {
    $var = $t->compile(template => $var, tag_start => '', tag_end => '', raw => 1);
  }
  return if not $var;

  $t->add_to_compiled("push \@p,\$system->dump($var,return=>1);");
}

1;