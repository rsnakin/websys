use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Announces;
use utf8;

sub save_announce {
  my $self = shift;
  my $in = $system->in;

  if(not $in->query('aid') or not $in->query('issue_id')) {
    return_html(to_json({error => '1'}));
  }

  my $a = Announces->new();
  my $aid = $a->save_announce(
    body => $in->query('aBody'),
    name => $in->query('aName'),
    path => $in->query('branche'),
    item => $in->query('sbranche'),
    issue_id => $in->query('issue_id'),
    announce_id => $in->query('aid'),
    ctime => $in->query('ctime')
  );

  return_html(to_json({issue_id => $aid}));
  
  $system->stop;
}

1;
