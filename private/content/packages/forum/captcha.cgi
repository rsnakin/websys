use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Image::Magick;
use Digest::MD5 qw(md5_hex);
use List::Util 'max';
use MIME::Base64;
use JSON -support_by_pp;
use Files;
use utf8;

sub captcha {
  my $self = shift;
  my $in = $system->in;

  my $files_obj = Files->new($system->config->get('captcha'));
  my $now = time();
  my $files = $files_obj->get_files();
  if($files) {
    foreach my $file (@$files) {
      # push @$test, $file->{ctime} . ' ' . ($now - 60 * 60 * 30);
      if($file->{ctime} < $now - 60 * 30) {
        unlink($file->{path});
      }
    }
  }
  # $system->dump($test, file => '/var/www/file2.dump');

  my $width = $in->query('width');
  my $height = $in->query('height');

  my @str = split('', md5_hex(rand()));
  my @text; my $n = 0;
  foreach my $i (@str) {
    next if $i eq '0' or $i eq 'o';
    last if $n > 5;
    if((rand() * 100) > 30) {
      push @text, $i;
      $n ++;
    } else {
      push @text, ' ';
    }
    
  }

  my $ret;
  my $phrase = join('', @text);
  my $code = uc(md5_hex(rand()));
  $ret->{phrase} = $phrase;
  $ret->{phrase} =~ s/ //g;
  $ret->{phrase} = md5_hex($ret->{phrase});
  $ret->{time} = time();

  require FWork::System::Utils;
  require FWork::System::File;

  FWork::System::Utils::create_dirs($system->config->get('captcha'));

  open(jfl, '>' . $system->config->get('captcha') . '/' . $code);
  print jfl to_json($ret);
  close(jfl);

  delete $ret->{phrase};
  delete $ret->{time};
  $ret->{code} = $code;
  $ret->{img} = $self->__make_img($phrase, $width, $height);
  # $system->dump($ret, file => '/var/www/dump.captcha');
  return_html(to_json($ret));

  $system->stop();
}

sub __make_img {
  my $self = shift;
  my $text = shift;
  my $width = shift;
  my $height = shift;

  my $color = 'grey';

  my @t = split(/\\n/, $text);
  my $w = max($width, 20 + 10*max(map { length } @t)); 
  my $h = max($height, 20 + 24*scalar(@t));

  my $img = Image::Magick->new;
  $img->Set(size => $w . 'x' . $h);
  $img->ReadImage('canvas:white');

  $img->Annotate(pointsize => $h * .75, fill => $color, 'x' => $w * .2, 'y' => $h * .8, text => $text);

  $img->Draw(	stroke			=>		$color, 
		strokewidth		=>		2*rand, 
		primitive		=>		'line', 
		points			=>		"0,$_ $w,$_"
		) for (map { $_*int($h / 6.0) } (0..5));

  $img->Draw(	stroke			=>		$color, 
		strokewidth		=>		2*rand, 
		primitive		=>		'line',  
		points			=>		"$_,0 $_,$h"
		) for (map { $_*int($w / 6.0) } (0..5));

  $img->Wave(amplitude => 1+5*rand, wavelength => 140+40*rand);
  # $img->Rotate(degrees => 15.0 + 25.0*rand);

  $w = $img->[0]->Get('width');
  $h = $img->[0]->Get('height');

  $img->Draw(	stroke			=>		$color, 
		strokewidth		=>		3*rand, 
		primitive		=>		'line', 
		points			=>		"0,$_ $w,$_"
		) for (map { $_*int($h / 5.0) } (0..9));

  $img->Draw(	stroke			=>		$color, 
		strokewidth		=>		3*rand, 
		primitive		=>		'line', 
		points			=>		"$_,0 $_,$h"
		) for (map { $_*int($w / 5.0) } (0..9));

  # $img->MotionBlur(radius => 5.0+25.0*rand, sigma => 3.0, angle => 90.0*rand);

  return('data:image/jpeg;base64,'. encode_base64($img->ImageToBlob(magick => 'jpeg')));
  # $system->dump($blobs, file => '/var/www/dump.captcha');
  # $img->Write("/var/www/output.png");

}
1;