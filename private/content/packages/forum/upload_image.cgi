use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use Forum;
use JSON -support_by_pp;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);
use utf8;

sub upload_image {
  my $self = shift;
  my $in = $system->in;

  my $imgData = from_json($in->query('imgData'));

  my $ret;

  if(not $self->{vars}->{fuser}->{uid}) {
      $ret->{error} = 'ERROR:BAD_USER';
      return_html(to_json($ret));
      $system->stop();
  }

  if(not $imgData->{imageBody} or not $imgData->{msgId} or not $imgData->{imageName}) {
      $ret->{error} = 'ERROR:BAD_PARAMS';
      return_html(to_json($ret));
      $system->stop();
  }

  if(length($imgData->{imageBody}) > 6000000) {
      $ret->{error} = 'ERROR:TOO_LONG[' . length($imgData->{imageBody}) . ']';
      return_html(to_json($ret));
      $system->stop();
  }

  my $upload_images_data = $system->config->get('upload_images_data');
  require FWork::System::Utils;
  require FWork::System::File;
  FWork::System::Utils::create_dirs($upload_images_data);
  my $imgTmpId = uc(md5_hex(localtime()) . md5_hex(rand()));
  $self->{progress_file} = $upload_images_data . '/' . $imgTmpId;

  $self->write_progress(10);
  my $pid = fork();

  if($pid != 0) {
    $ret->{ok} = 'YES';
    $ret->{imgTmpId} = $imgTmpId;
    return_html(to_json($ret));
    $system->stop();
  } else {
    close(STDIN);
    close(STDOUT);
    close(STDERR);
    use Image::Magick;

    $self->write_progress(20);
    $imgData->{imageBody} =~ s/data:image\/(.+?);base64,//;

    open(flog, '>>/var/www/upload_images.log');
    print flog "\n" . $imgData->{imageName} . "\n";

    $imgData->{imageName} = uc(md5_hex(localtime(). rand() . rand())) . '.' . $1;

    my @midarr = split('', $imgData->{msgId});

    my $path = $system->config->get('users_images_path');

    foreach my $s (0..4) {
      $path .= '/' . $midarr[$s];
    }
    $path .= '/' . $imgData->{msgId};

    FWork::System::Utils::create_dirs($path);
    FWork::System::Utils::create_dirs($path . '/prev');

    $self->write_progress(30);

    my $image=Image::Magick->new();
    $image->BlobToImage(decode_base64($imgData->{imageBody}));

    $self->write_progress(50);

    my $width  = $image->Get('width');
    my $height = $image->Get('height');
    my $aspect = 1. * $width / $height;

    print flog "$width x $height ($aspect)\n";

    my $nW;
    my $nH;

    if($width > $height) {
      $nW = 2000;
      $nH = $nW / $aspect;
    } else {
      $nH = 2000;
      $nW = $nH * $aspect;
    }

    print flog "$nW x $nH ($aspect)\n";

    $image->Resize(geometry => $nW . 'x' . $nH);

    $self->write_progress(80);

    $image->Write($path . '/' . $imgData->{imageName});

    $self->write_progress(85);

    # if($width < $height) {
    #   $nW = 500;
    #   $nH = $nW / $aspect;
    # } else {
      $nH = 500;
      $nW = $nH * $aspect;
    # }

    $image->Resize(geometry => $nW . 'x' . $nH);

    # print flog "$nW x $nH ($aspect)\n";

    # my $crop;
    # if($width < $height) {
    #   $nW = 500;
    #   $nH = $nW / $aspect;
    #   # $crop = ($nH - 500) / 2;
    #   # $image->Crop(x => 0, y => $crop);
    #   $crop = '500x500+0+' . (($nH - 500) / 2);
    # } else {
    #   $nH = 500;
    #   $nW = $nH * $aspect;
    #   $crop = '500x500+' . (($nW - 500) / 2) . '+0';
    # }

    # print flog "$nW x $nH $crop ($aspect)\n";

    close(flog);

    # $image->Crop('500x500');

    $self->write_progress(90);

    $image->Write($path . '/prev/' . $imgData->{imageName});

    $self->write_progress(100);

    $system->stop();
  }
}

sub write_progress {
  my $self = shift;
  my $progress = shift;
  
  if($self->{progress_file}) {
    open(fl, '>' . $self->{progress_file});
    print fl to_json({progress => $progress});
    close(fl);
  }
}

1;
