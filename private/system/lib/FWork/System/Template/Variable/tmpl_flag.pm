use strict;
use vars qw($defs);

$defs->{tmpl_flag} = {
  pattern => qr/^tmpl_flag\.(.+)$/o,
  handler => \&tmpl_flag,
  version => 1.0,
};

sub tmpl_flag { 
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $var = $self->{params}->[0];
  my $parsed = $self->{template}->compile(
    template  => $var, 
    tag_start => '<', 
    tag_end   => '>', 
    raw       => 1, 
  );
  return $self->optimize('$s->{flags}->{'.$parsed.'}');
}

1;