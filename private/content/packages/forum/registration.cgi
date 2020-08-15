use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);
use utf8;

sub registration {
  my $self = shift;
  my $in = $system->in;

  my $regData = from_json($in->query('regData'));

  my $ret;
  if( -e $system->config->get('captcha') . '/' . $regData->{captchaCode}) {
    open(jfl, '<' . $system->config->get('captcha') . '/' . $regData->{captchaCode});
    my $json;
    while(my $l = <jfl>) {
      $json .= $l;
    }
    close(jfl);
    unlink($system->config->get('captcha') . '/' . $regData->{captchaCode});
    my $captcha_data;
    eval('$captcha_data = from_json($json)');
    if($@) {
      $ret->{errors}->{captcha} = 'ERROR';
      return_html(to_json($ret));
      $system->stop();
    }
    if($captcha_data->{phrase} ne md5_hex($regData->{captcha})) {
      $ret->{errors}->{captcha} = 'ERROR';
      return_html(to_json($ret));
      $system->stop();
    }
  } else {
      $ret->{errors}->{captcha} = 'ERROR';
      return_html(to_json($ret));
      $system->stop();
  }

  if($regData->{password0} ne $regData->{password1}) {
      $ret->{errors}->{password} = 'ERROR';
      return_html(to_json($ret));
      $system->stop();
  }

  my $f_obj = Forum->new('fragen_antworten');
  my $uid = $f_obj->add_user(
    uname => $regData->{name},
    uvorname => $regData->{vorname},
    uemail => $regData->{email},
    login => $regData->{ulogin},
    password => $regData->{password0},
    sex => $regData->{sex}
  );

  if(not $uid) {
    $ret->{errors}->{user} = $f_obj->{error};
    return_html(to_json($ret));
    $system->stop();
  }

  if($regData->{avatar}) {
    $regData->{avatar} =~ s/data:image\/(.+?);base64,//;
    $system->dump($system->config->get('fusers_avatars') . '/' . $uid . '.' . $1, file => '/var/www/registration.dump');
    open my $fh, '>', $system->config->get('fusers_avatars') . '/' . $uid . '.' . $1;
    binmode $fh;
    print $fh decode_base64($regData->{avatar});
    close $fh;
  }

  $ret->{user} = $uid;

  return_html(to_json($ret));

  $system->stop();
}

1;
