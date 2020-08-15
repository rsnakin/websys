use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub delete_msg {
  my $self = shift;
  my $in = $system->in;

  if(not $self->{vars}->{fuser}->{uid}) {
    return_html(to_json({status => 'error'}));
    $system->stop();
  }

  my $f_obj = Forum->new('fragen_antworten');
  my $msg = $f_obj->get_message($in->query('mid'), $self->{vars}->{fuser}->{uid});

  if($msg->{owner} eq 'Y') {
    $f_obj->delete_msg($in->query('mid'), $self->{vars}->{fuser}->{uid});
    return_html(to_json({status => 'ok'}));
  } else {
    return_html(to_json({status => 'error'}));
  }

  $system->stop();
}

1;
