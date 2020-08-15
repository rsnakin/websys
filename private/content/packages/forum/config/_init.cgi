use strict;
use FWork::System;
use JSON -support_by_pp;
use utf8;

  my $AVATAR = {
    '0' => 'female.png',
    '1' => 'male.png'
  };

sub _init {
  my $self = shift;
  my $in = $system->in; 
  $self->{vars}->{login} = undef;
  if($in->cookie('uid')) {
    if( -e $system->config->get('fusers') . '/' . $in->cookie('uid')) {
      open(ifl, '<'. $system->config->get('fusers') . '/' . $in->cookie('uid')) || return undef;
      my $udata;
      while(my $l = <ifl>) {
        $udata .= $l;
      }
      my $u;
      eval('$u = from_json($udata);');
      if($@) {
        return;
      }
      if($u->{key} eq $in->cookie('uid')) {
        if( -e $system->config->get('fusers_avatars') . '/' . $u->{uid} . '.png') {
          $u->{avatar} = $system->config->get('fusers_avatars_url') . '/' . $u->{uid} . '.png';
        } else {
          $u->{avatar} = $system->config->get('fusers_avatars_url') . '/' . $AVATAR->{$u->{sex}};
        }
        $self->{vars}->{login} = 'yes';
        $self->{vars}->{fuser} = $u;
        # $system->dump($self->{vars}->{user});
        return;
      }
    }
  }
  $system->out->cookie(
    name    => 'uid',
    value   => '',
    expires => '-30d'
  );
}

1;
