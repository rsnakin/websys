use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub save_msg_edit {
  my $self = shift;
  my $in = $system->in;

  my $msg = from_json($in->query('msg'));

  $system->dump($msg, file => '/var/www/save_msg_edit.dump');

  if(not $self->{vars}->{fuser}->{uid} or not $msg->{body} or not $msg->{mid}) {
    return_html(to_json({msg => undef, status => 'error', errDesc => 'BAD_PARAMS'}));
    $system->stop();
  }

  my $f_obj = Forum->new('fragen_antworten');

  my $nmsg = $f_obj->get_message($msg->{mid}, $self->{vars}->{fuser}->{uid});

  if($nmsg->{owner} ne 'Y') {
    return_html(to_json({msg => undef, status => 'error', errDesc => 'NOT_OWNER'}));
    $system->stop();
  }

  my $html = {
    "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;","'" => "&#39;", "\r" => "",
    "&" => "&amp;"
  };
  
  $msg->{body} =~ s/(<|>|"|'|\r|&)/$html->{$1}/go;

  $f_obj->update_message(
    mid => $msg->{mid},
    mbody => $msg->{body},
    maid => undef
  );

  my $path = $system->config->get('users_images_path');
  my @midarr = split('', $msg->{mid});
  foreach my $s (0..4) {
      $path .= '/' . $midarr[$s];
    }
  # my $test;
  if($msg->{deleteImg}) {
    foreach my $i (@{$msg->{deleteImg}}) {
      unlink($path . '/' . $msg->{mid} . '/' . $i);
      unlink($path . '/' . $msg->{mid} . '/prev/' . $i);
    }
  }
  my $smsg = $f_obj->get_message($msg->{mid}, $self->{vars}->{fuser}->{uid});

  if(not $smsg->{mbody}) {
    return_html(to_json({msg => undef, status => 'error', errDesc => 'NOT_SAVED_MSG'}));
    $system->stop();
  }
  # $system->dump($test, file => '/var/www/msgImg.dump');

  return_html(to_json({readed => $smsg->{readed}, msg => $smsg->{mbody}, images => $smsg->{images}, url => $smsg->{url}, status => 'ok', mutime => $smsg->{mutime}, mtime => $smsg->{mtime}}));
  $system->stop();
}

1;
