use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use Digest::MD5 qw(md5_hex);
use JSON -support_by_pp;
use Image::Magick;
use Models;
use MIME::Base64;

sub bind_bg {
  my $self = shift;
  my $in = $system->in;

  my $json = JSON->new();
  $json->allow_singlequote();

  my $obj = Models->new();
  $obj->add_bg_link($in->query('model_id'), $in->query('bgid'));
  
  
  return_html(to_json( { status => 'ok' } ));
}

1;
