use strict;
use FWork::System;
use TitlesBg;
use utf8;

sub titlesbg {
  my $self = shift;
  my $in = $system->in;

  my $obj = TitlesBg->new();

  if($in->query('delete')) {
    $obj->remove_bg($in->query('bg_id'));
  }
  
  if($in->query('add')) {
    $obj->add_bg($in->query('bg_name'));
  }

  $self->{vars}->{bgs} = $obj->get_all_bg();
  
  $self->{vars}->{action} = 'titlesbg';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
