use strict;
use FWork::System;
use Time::Local 'timelocal';
use utf8;
use FWork::System::Ajax qw(&return_html);
use Issues;

sub save_issue {
  my $self = shift;
  my $in = $system->in;
  my $itime;
  my $issues = Issues->new();
  if($in->query('itime') =~ /(\d\d)\.(\d\d)\.(\d\d\d\d) (\d\d)\:(\d\d)/) {
    $itime = timelocal(0, $5, $4, $1, $2-1, $3);
  }
  if(not $itime) {
    return_html('{"status":"error"}');
    $system->stop;
  }
  # $system->dump($in);
  $issues->save_issue(
    body => $in->query('ibody'),
    name => $in->query('iname'),
    path => $in->query('branche'),
    item => $in->query('sbranche'),
    issue_id => $in->query('issue_id'),
    date_time => $itime,
  );

  return_html('{"status":"ok"}');
  $system->stop;
}

1;
