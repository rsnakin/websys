use strict;
use FWork::System;
use utf8;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;

sub load_structure {
  my $self = shift;
  my $structure;

  open(sfl, '<' . $system->config->get('structure_file'));
  while(my $l = <sfl>) {
    $structure .= $l;
  }
  close(sfl);
  
  
  
  my $ret;
  $ret->{structure} = from_json($structure);
  $ret->{fuser}->{uname} = $self->{vars}->{fuser}->{uname};
  $ret->{fuser}->{avatar} = $self->{vars}->{fuser}->{avatar};
  $ret->{fuser}->{uvorname} = $self->{vars}->{fuser}->{uvorname};
  
  $system->dump($ret, file => '/var/www/structure.dump');

  return_html(to_json($ret));
  $system->stop;
}

1;
