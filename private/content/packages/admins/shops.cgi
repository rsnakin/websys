use strict;
use FWork::System;
use utf8;
use Shops;

sub shops {
  my $self = shift;
  my $in = $system->in;
  
  my $shops = Shops->new();
  
  $self->{vars}->{shops} = $shops->get_shops();

  $self->{vars}->{action} = 'shops';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
