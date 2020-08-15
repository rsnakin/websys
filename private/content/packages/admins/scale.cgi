use strict;
use FWork::System;
use utf8;

sub scale {
  my $self = shift;
  my $in = $system->in;
  

  $self->{vars}->{action} = 'scale';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
