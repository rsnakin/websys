use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;
use Digest::MD5 qw(md5_hex);
# use Issues;
# use Structure;
use utf8;

sub carousel_save {
  my $self = shift;
  my $in = $system->in;

  # $system->dump($in, file => '/var/www/1213.dump');

  require FWork::System::Utils;
  require FWork::System::File;

  my $carousel_file = $system->config->get('carousel_file');
  my $carousel_imgs = $system->config->get('carousel_imgs');

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

  my $edit_item = $carousel->{$in->query('cid')};
  if(not $edit_item) {
    return_html(to_json({error => 'ItemNotFound!'}));
    $system->stop();
  }

  my $sort_id = $edit_item->{sort_id};
  my $file = $edit_item->{file};
  my $file_content = $in->query('file')->{file}->set_binmode->contents if $in->query('file') and $in->query('file') ne 'undefined';

  if($file_content) {
    unlink($carousel_imgs . '/' . $edit_item->{file});
    open(img, '>'. $carousel_imgs .'/' . $in->query('file')->{filename});
    print img $file_content;
    close(img);
    $file = $in->query('file')->{filename};
  }

  $carousel->{$in->query('cid')} = {
    path => $in->query('branche'),
    item => $in->query('sbranche'),
    name => $in->query('bName'),
    file => $file,
    sort_id => $sort_id
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
