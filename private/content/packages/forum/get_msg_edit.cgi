use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub get_msg_edit {
  my $self = shift;
  my $in = $system->in;

  my $f_obj = Forum->new('fragen_antworten');
  my $msg = $f_obj->get_message($in->query('mid'), $self->{vars}->{fuser}->{uid});

  if($msg->{owner} eq 'Y') {
    return_html(to_json({msg => $msg->{mbody}, status => 'ok'}));
  } else {
    return_html(to_json({msg => undef, status => 'error'}));
  }

  $system->stop();
}

1;
