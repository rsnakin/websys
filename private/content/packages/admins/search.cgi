use strict;
use FWork::System;
use utf8;

sub search {
  my $self = shift;
  my $in = $system->in;
  

  $self->{vars}->{action} = 'search';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
