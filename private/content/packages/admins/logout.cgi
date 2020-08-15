use strict;
use FWork::System;
use utf8;

sub logout {
  my $self = shift;

  $system->out->cookie(
    name    => 'key',
    value   => '',
    expires => '-30d'
  );
  $system->out->cookie(
    name    => 'data',
    value   => '',
    expires => '-30d'
  );
  $system->out->cookie(
    name    => 'u',
    value   => '',
    expires => '-30d'
  );
  $system->out->redirect('/admin.html');
  $system->stop;
}

1;
