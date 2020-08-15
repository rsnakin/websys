use strict;
use FWork::System;
use Category;
use Brand;
use Mark;
use Models;
use utf8;

sub models {
  my $self = shift;
  my $in = $system->in;

  $self->{vars}->{cats} = Category->new()->get_all_categories();
  $self->{vars}->{brands} = Brand->new()->get_all_brands();
  $self->{vars}->{marks} = Mark->new()->get_all_marks();
  $self->{vars}->{models} = Models->new()->get_all_models();
  
#   $system->dump($self->{vars}->{models});
  
  $self->{vars}->{action} = 'models';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
