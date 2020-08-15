use strict;
use FWork::System;
use utf8;
use Structure;
use Forum;
use JSON -support_by_pp;

sub index {
  my $self = shift;
  my $in = $system->in;

  $self->{vars}->{page} = '/forum';
  my $sobj = Structure->new();
  $self->{vars}->{menu} = $sobj->get_structure();
  $self->{vars}->{server_time} = time();

  $self->{vars}->{rand} = rand();

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
