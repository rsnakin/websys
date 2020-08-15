use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use Digest::MD5 qw(md5_hex);
use JSON -support_by_pp;
use Image::Magick;

sub upload_bg {
  my $self = shift;
  my $in = $system->in;
  require FWork::System::Utils;
  require FWork::System::File;
  my $json = JSON->new();
  $json->allow_singlequote();
  my $width = 1180;
  my $file_content;
  if($in->{__stdin}) {
    $file_content = $in->{__stdin};
  } else {
    $file_content = $in->query('file')->{file}->set_binmode->contents if $in->query('file');
  }

  if(not $file_content) {
    return_html(to_json({error => 'PhotoNotFound!'}));
    $system->stop();
  }

  my $image = Image::Magick->new;
  $image->BlobToImage($file_content);

  my ($x, $y, $format) = map {lc($_)} $image->Get('columns', 'rows', 'magick');

  if($x < 1180) {
    return_html(to_json({error => 'PhotoTooSmall'}));
    $system->stop();
  }

  $image->Resize(geometry => $width . 'x' . int($y * $width / $x));
#   $image->Set(monochrome => 'True');
  $image->Set(type => 'GrayscaleMatte');
  
#   my $photo = {};
#   $photo->{large} = FWork::System::Utils::resize_image(
#     image_data      => $file_content,
#     width           => $width,
#     height          => int($y * $width / $x),
#     accept_formats  => ['jpeg', 'bmp'],
#     exact           => 1,
#   );
# 
#   if(not $photo->{large}) {
#     return_html(to_json({ error => 'DataError'}));
#     $system->stop();
#   }

  my $photo_id = uc(md5_hex(rand()));
  $image->Write($system->config->get('titlesbg_path') . '/' . $photo_id . '.jpg');
#   my $new_file = $system->config->get('titlesbg_path') . '/' . $photo_id . '.jpg';

#   my $file = FWork::System::File->new($new_file, 'w', {
#     is_binary => 1,
#     access    => 0664,
#   }) || die "Can't create file $new_file: $!";
#   $file->print($photo->{large})->close;

#   $system->dump($in, file => '/tmp/upload_picture.dump');
  my ($x, $y, $format) = map {lc($_)} $image->Get('columns', 'rows', 'magick');
  return_html(to_json({
    url => $system->config->get('titlesbg_url') . '/' . $photo_id . '.jpg',
    image_id => $photo_id,
    x => $x,
    y => $y
  }));
  $system->stop;
}

1;
