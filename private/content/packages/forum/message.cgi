use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub message {
  my $self = shift;
  my $in = $system->in;

  my $ret;

  my $msg = from_json($in->query('msg'));

  if(not $self->{vars}->{fuser}->{uid}) {
    $ret->{ok} = 'yes';
    return_html(to_json($ret));
    $system->stop();
  }

  my $f_obj = Forum->new('fragen_antworten');

  my $html = {
    "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;","'" => "&#39;", "\r" => "",
    "&" => "&amp;"
  };
  
  $msg->{body} =~ s/(<|>|"|'|\r|&)/$html->{$1}/go;

  my $msg_id = $f_obj->get_id();
  $f_obj->add_message(
    mid => $msg_id,
    muid => $self->{vars}->{fuser}->{uid},
    mbody => $msg->{body},
    lock => $msg->{lock},
    maid => undef
  );

  $ret->{ok} = 'yes';
  $ret->{mid} = $msg_id;
  return_html(to_json($ret));
  $system->stop();
}

1;
