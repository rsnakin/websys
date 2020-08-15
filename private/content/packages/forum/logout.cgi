use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub logout {
  my $self = shift;
  my $in = $system->in;

  my $ret;

  # $system->dump($self->{vars}->{fuser}, file => '/var/www/logout.dump');

  if(not $self->{vars}->{fuser}->{uid}) {
    $ret->{ok} = 'yes';
    return_html(to_json($ret));
    $system->stop();
  }

  my $f_obj = Forum->new('fragen_antworten');

  my $user = $f_obj->logout_user($self->{vars}->{fuser}->{key});

  $system->out->cookie(
    name    => 'uid',
    value   => '',
    expires => '-30d'
  );

  $ret->{ok} = 'yes';
  return_html(to_json($ret));
  $system->stop();
}

1;
