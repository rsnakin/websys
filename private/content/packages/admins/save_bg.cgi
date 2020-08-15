use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use Digest::MD5 qw(md5_hex);
use JSON -support_by_pp;
use Image::Magick;
use TitlesBg;
use MIME::Base64;

sub save_bg {
  my $self = shift;
  my $in = $system->in;

  my $json = JSON->new();
  $json->allow_singlequote();

  my @blob;
  my $image = Image::Magick->new();
  $image->Set(size=>$in->query('width') . 'x' . $in->query('height'));
  my $blob = decode_base64((split(',', $in->query('imgblob')))[1]);
  $image->BlobToImage($blob);
  my $image_id = $in->query('image_id');
  my $file = $image_id . '.jpg';
  my $path = $system->config->get('titlesbg_path') . '/' . $file;
  my $url = $system->config->get('titlesbg_url') . '/' . $file;
  $image->Crop(geometry => $in->query('rectx') . 'x' . $in->query('recty') . '+' 
    . ($in->query('x') - $in->query('rectx')/2) .'+' . ($in->query('y') - $in->query('recty')/2));
  $image->Write($path);
  my $obj = TitlesBg->new();
  $obj->add_bg($image_id);
  return_html(to_json( { url => $url } ));
}

1;
