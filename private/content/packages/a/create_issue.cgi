use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Issues;
use utf8;

sub create_issue {
  my $self = shift;
  my $in = $system->in;
  # $system->dump($in);
  my $json = JSON->new();
  $json->allow_singlequote();

  # $self->{vars}->{page} = 'issues';
  # my $structure = Structure->new();
  # $self->{vars}->{menu} = $structure->get_structure();
  # $system->dump($self);
  my $issues = Issues->new();
  my $issue_id = $issues->get_id();
  if($issues->check_name($in->query('bName'))) {
    return_html('{"error":"1"}');
    $system->stop;
  }
  $issues->create_issue(
    name => $in->query('bName'),
    path => $in->query('branche'),
    item => $in->query('sbranche'),
    issue_id => $issue_id
  );

  return_html(to_json({issue_id => $issue_id}));
  
  $system->stop;
}

1;
