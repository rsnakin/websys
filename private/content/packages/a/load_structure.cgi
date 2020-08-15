use strict;
use FWork::System;
use utf8;
use FWork::System::Ajax qw(&return_html);

sub load_structure {
  my $self = shift;
  my $structure;

  open(sfl, '<' . $system->config->get('structure_file'));
  while(my $l = <sfl>) {
    $structure .= $l;
  }
  close(sfl);
  
  return_html($structure);
  $system->stop;
}

1;
