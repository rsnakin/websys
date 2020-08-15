use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use utf8;

sub check_email {
  my $self = shift;
  my $in = $system->in;

  return_html(to_json(Forum->new('fragen_antworten')->check_email($in->query('email'))));

  $system->stop();
}

1;
