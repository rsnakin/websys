use strict;
use vars qw($defs);

$defs->{query} = {
  pattern => qr/^query\.(.+)$/o,
  handler => \&query,
  version => 1.0,
};

sub query { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $var = $self->{params}->[0];
  my $parsed = $self->{template}->compile(
    template  => $var, 
    tag_start => '<', 
    tag_end   => '>', 
    raw       => 1, 
  );
  return $self->optimize('$in->query('.$parsed.')');
}

1;