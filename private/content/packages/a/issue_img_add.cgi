use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Digest::MD5 qw(md5_hex);
use Issues;
use utf8;

sub issue_img_add {
  my $self = shift;
  my $in = $system->in;

  require FWork::System::Utils;
  require FWork::System::File;

  my $issue_img_path = $system->config->get('issue_img_path');
  my $issue_img_url = $system->config->get('issue_img_url');

  my $issue_imgs = $issue_img_path . '/' . $in->query('issue_id');

  FWork::System::Utils::create_dirs($issue_imgs);

  my $file_content = $in->query('file')->{file}->set_binmode->contents if $in->query('file');

  if(not $file_content) {
    return_html(to_json({error => 'PhotoNotFound!'}));
    $system->stop();
  }

  if( -e $issue_imgs .'/' . $in->query('file')->{filename} ) {
    return_html(to_json({error => 'FileAlreadyExist!'}));
    $system->stop();
  }

  open(img, '>'. $issue_imgs .'/' . lc($in->query('file')->{filename}));
  print img $file_content;
  close(img);

  return_html(to_json({error => 'none'}));
  $system->stop();
  $system->stop;
}

1;
