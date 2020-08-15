use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub check_login {
  my $self = shift;
  my $in = $system->in;

  return_html(to_json(Forum->new('fragen_antworten')->check_login($in->query('login'))));

  $system->stop();
}

1;
