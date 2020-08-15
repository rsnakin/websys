use strict;
use FWork::System;
use utf8;
use FWork::System::Ajax qw(&return_html);

sub save_structure {
  my $self = shift;
  my $in = $system->in;

  if(not $in->query('structure')) {
    return_html('{"status":"error"}');
    $system->stop;
  }

  open(sfl, '>' . $system->config->get('structure_file'));
  print sfl $in->query('structure');
  close(sfl);
  return_html('{"status":"ok"}');
  $system->stop;
}

1;
