use strict;
use FWork::System;
use utf8;

sub index {
  my $self = shift;
  my $in = $system->in;
  
  foreach my $e (sort keys %ENV) { 
    push @{$self->{vars}->{envs}}, { name => $e,  value => $ENV{$e}}; 
  }

  $self->{vars}->{action} = 'index';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
