use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Structure;
use Forum;
use JSON -support_by_pp;
use utf8;

sub get_msg {
  my $self = shift;
  my $in = $system->in;

# /cgi-bin/index.cgi?pkg=content:forum&action=get_msg&page=10

    return_html(to_json(Forum->new('fragen_antworten')->get_messages(
      page => $in->query('page'),
      start => $in->query('start'),
      uid => $self->{vars}->{fuser}->{uid}
    )));

#  $system->dump($self);
  $system->stop();
}

1;
