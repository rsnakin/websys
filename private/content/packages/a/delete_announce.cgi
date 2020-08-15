use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Announces;
use utf8;

sub delete_announce {
  my $self = shift;
  my $in = $system->in;

  if(not $in->query('aid') or not $in->query('issue_id')) {
    return_html(to_json({error => '1'}));
  }

  my $a = Announces->new();
  my $aid = $a->delete_announce($in->query('issue_id'), $in->query('aid'));

  return_html(to_json({issue_id => $aid}));
  
  $system->stop;
}

1;
