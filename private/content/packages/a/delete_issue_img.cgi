use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use utf8;

sub delete_issue_img {
  my $self = shift;
  my $in = $system->in;

  my $issue_img_path = $system->config->get('issue_img_path');

  my $issue_img = $issue_img_path . '/' . $in->query('issue_id') . '/' . $in->query('img');

  if(! -e $issue_img) {
    return_html(to_json({error => 'PhotoNotFound!'}));
    $system->stop();
  }

  unlink($issue_img);

  return_html(to_json({error => 'none'}));
  $system->stop();
}

1;
