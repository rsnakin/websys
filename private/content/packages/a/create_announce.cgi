use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Announces;
use utf8;

sub create_announce {
  my $self = shift;
  my $in = $system->in;

  # $self->{vars}->{page} = 'issues';
  # my $structure = Structure->new();
  # $self->{vars}->{menu} = $structure->get_structure();
  # $system->dump($self);
  my $a = Announces->new();
  my $aid = $a->create_announce(
    name => $in->query('aName'),
    body => $in->query('aBody'),
    path => $in->query('branche'),
    item => $in->query('sbranche'),
    issue_id => $in->query('issue_id')
  );

  return_html(to_json({issue_id => $aid}));
  
  $system->stop;
}

1;
