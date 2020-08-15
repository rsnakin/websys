use strict;
use FWork::System;
use utf8;

sub index {
  my $self = shift;
  my $in = $system->in;

  $self->{vars}->{page} = 'index';

  # $system->dump($self);

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
