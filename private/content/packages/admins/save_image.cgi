use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use Digest::MD5 qw(md5_hex);
use JSON -support_by_pp;
use Image::Magick;
use Models;

sub save_image {
  my $self = shift;
  my $in = $system->in;
  if(-e $system->config->get('images_path') . '/' . $in->query('image_id') . '.jpg') {
    require FWork::System::Utils;
    require FWork::System::File;
    my $json = JSON->new();
    $json->allow_singlequote();
    my $image = Image::Magick->new();
    $image->Read($system->config->get('images_path') . '/' . $in->query('image_id') . '.jpg');
    my ($image_width, $image_height, $format) = map {lc($_)} $image->Get('columns', 'rows', 'magick');
    FWork::System::Utils::create_dirs($system->config->get('images_path') . '/' . $in->query('image_id'));
    $image->Write($system->config->get('images_path'). '/' . $in->query('image_id') . '/a.jpg');
    $image->Crop(geometry => $in->query('rectx') . 'x' . $in->query('recty') . '+' 
    . ($in->query('x') - $in->query('rectx')/2) .'+' . ($in->query('y') - $in->query('recty')/2));
    $image->Write($system->config->get('images_path'). '/' . $in->query('image_id') . '/b.jpg');
    $image->Resize(geometry => '210x210');
    $image->Write($system->config->get('images_path'). '/' . $in->query('image_id') . '/c.jpg');
    $image->Resize(geometry => '100x100');
    $image->Write($system->config->get('images_path'). '/' . $in->query('image_id') . '/d.jpg');
    Models->new()->save_image(
      image_name => $in->query('image_id'),
      model_id => $in->query('model_id'),
      image_width => $image_width,
      image_height => $image_height
    );
    unlink($system->config->get('images_path') . '/' . $in->query('image_id') . '.jpg');
    return_html($in->query('image_id'));
  } else {
    return_html('error');
  }
  $system->stop;
}

1;
