use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Structure;
use Forum;
use JSON -support_by_pp;
use utf8;

sub get_comments {
  my $self = shift;
  my $in = $system->in;

  my $f_obj = Forum->new('fragen_antworten');

  if($self->{vars}->{fuser}->{uid}) {
    $f_obj->update_reader(
      rmid => $in->query('mid'),
      ruid => $self->{vars}->{fuser}->{uid}
    );
  }

  my $msg = $f_obj->get_message($in->query('mid'), $self->{vars}->{fuser}->{uid});
  
  $system->dump($msg, file => '/var/www/msg_get.dump');

  return_html(to_json({mainMsg => $msg, comments => []}));

  $system->stop();
}

1;
