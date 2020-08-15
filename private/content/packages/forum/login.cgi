use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub login {
  my $self = shift;
  my $in = $system->in;

  my $loginData;
  my $ret;

  eval('$loginData = from_json($in->query(\'loginData\'));');
  if($@) {
      $ret->{error} = 'yes';
      return_html(to_json($ret));
      $system->stop();
  }


  my $ret;
  my $f_obj = Forum->new('fragen_antworten');

  my $user = $f_obj->login_user(
    login => $loginData->{login},
    password => $loginData->{password}
  );

  if(not $user) {
    $ret->{error} = 'yes';
    return_html(to_json($ret));
    $system->stop();
  }

  $system->out->cookie(
    name    => 'uid',
    value   => $user->{key},
    expires => '+30d'
  );

  $ret->{ok} = 'yes';
  return_html(to_json($ret));
  $system->stop();
}

1;
