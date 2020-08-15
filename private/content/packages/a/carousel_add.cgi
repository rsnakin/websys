use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Digest::MD5 qw(md5_hex);
# use Issues;
# use Structure;
use utf8;

sub carousel_add {
  my $self = shift;
  my $in = $system->in;

  require FWork::System::Utils;
  require FWork::System::File;

  my $carousel_file = $system->config->get('carousel_file');
  my $carousel_imgs = $system->config->get('carousel_imgs');

  my $file_content = $in->query('file')->{file}->set_binmode->contents if $in->query('file');

  if(not $file_content) {
    return_html(to_json({error => 'PhotoNotFound!'}));
    $system->stop();
  }

  if( -e $carousel_imgs .'/' . $in->query('file')->{filename} ) {
    return_html(to_json({error => 'FileAlreadyExist!'}));
    $system->stop();
  }

  open(img, '>'. $carousel_imgs .'/' . $in->query('file')->{filename});
  print img $file_content;
  close(img);

  my $crsl;
  my $carousel;

  if( -e $carousel_file ) {
    open(cfl, '<' . $carousel_file);
    while(my $l = <cfl>) {
      $crsl .= $l;
    }
    close(cfl);
    $carousel = from_json($crsl);
  }

  foreach my $cid (keys %{$carousel}) {
    $carousel->{$cid}->{sort_id} ++;
  }

  $carousel->{uc(md5_hex(localtime() . rand()))} = {
    path => $in->query('branche'),
    item => $in->query('sbranche'),
    name => $in->query('bName'),
    file => $in->query('file')->{filename},
    sort_id => 1
  };

  # $system->dump($carousel, file => '/var/www/1213.dump');

  open(cfl, '>' . $carousel_file);
  print cfl to_json($carousel);
  close(cfl);

  return_html(to_json({error => 'none'}));
  $system->stop();
  $system->stop;
}

1;
