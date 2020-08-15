# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 743 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/resize_image.al)"
sub resize_image {
  my $in = {
    image_data      => undef, # required, binary image data
    width           => undef, # required, target width of image
    height          => undef, # required, target height of image
    exact           => undef, # optional flag, that will force the width and
                              # height specified, cropping the image if required
    accept_formats  => undef, # optional, array ref of file formats that should 
                              # be accepted (jpeg, gif, etc)
    @_
  };
  
  my $image_data = $in->{image_data};
  my $width = $in->{width};
  my $height = $in->{height};   
  my $exact = $in->{exact};
  my $accept_formats = $in->{accept_formats};
  return undef if false($image_data) or false($width) or false($height);
  
  # if Image::Magick failed to load we just return the original data
  eval {require Image::Magick} || return $image_data;  

  my $image = Image::Magick->new;
  $image->BlobToImage($image_data);

  my ($x, $y, $format) = map {lc($_)} $image->Get('columns', 'rows', 'magick');

  if (ref $accept_formats eq 'ARRAY') {
    my $accept_idx = {map {lc($_) => 1} @$accept_formats};
    return undef if not $accept_idx->{$format};  
  }
  
  # no transformations required, returning image back
  if ($x <= $width and $y <= $height) {
    return $image_data;
  }

  my $geometry;
  if ($exact) {
    if ($x > $y) {
      $geometry = 'x'.$height;
    } else {
      $geometry = $width.'x';
    }
  } else {
    $geometry = $width.'x'.$height;
  }
  $image->Resize(geometry => $geometry);

  # returning back with a new image, if exact size is not required, otherwise
  # continue with cropping
  if (not $exact) {
    my @blobs = $image->ImageToBlob;
    return image => $blobs[0];
  }

  # new x and y sizes
  ($x, $y) = $image->Get('columns', 'rows');

  # cropping image now because the size is still not exact
  if ($x != $width || $y != $height) {
    $geometry = $width.'x'.$height;
    if ($x > $y) {
      my $x_offset = int(($x - $width) / 2);
      $geometry .= '+'.$x_offset.'+0';
    } else {
      my $y_offset = int(($y - $height) / 2);
      $geometry .= '+0+'.$y_offset;
    }
    $image->Crop($geometry);
  }
  
  my @blobs = $image->ImageToBlob;
  return $blobs[0];
}

# end of FWork::System::Utils::resize_image
1;
