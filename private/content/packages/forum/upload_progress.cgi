use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);
use utf8;

sub upload_progress {
  my $self = shift;
  my $in = $system->in;

  my $imgId = $in->query('imgTmpId');

  my $ret;

  if(not $self->{vars}->{fuser}->{uid}) {
      $ret->{error} = 'ERROR:BAD_USER';
      return_html(to_json($ret));
      $system->stop();
  }
  if(not $imgId) {
      $ret->{error} = 'ERROR:BAD_PARAMS';
      return_html(to_json($ret));
      $system->stop();
  }

  my $prImg = $system->config->get('upload_images_data') . '/' . $imgId;

  if(! -e $prImg) {
      $ret->{error} = 'ERROR:NOT_DATA';
      return_html(to_json($ret));
      $system->stop();
  }

  my $content;
  open(prFl, '<' . $prImg);
  while(my $l = <prFl>) {
    $content .= $l;
  }
  close(prFl);

  my $imgData;
  eval('$imgData = from_json($content)');
  if($@) {
      $ret->{error} = 'ERROR:IMG_DATA:' . $@;
      open(flog, '>>/var/www/progerss_errors.txt');
      print flog 'ERROR:IMG_DATA:' . $@ . "\n";
      close(flog);
      $imgData->{progress} = 50;
      $ret->{imgData} = $imgData;
      $ret->{ok} = 'YES';
      return_html(to_json($ret));
      # $system->stop();
  }

  if($imgData->{progress} == 100) {
    unlink($prImg);
  }

  $ret->{imgData} = $imgData;
  $ret->{ok} = 'YES';
  return_html(to_json($ret));
  $system->stop();
}

1;
