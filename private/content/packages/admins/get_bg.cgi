use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use JSON -support_by_pp;
use Models;

sub get_bg {
  my $self = shift;
  my $in = $system->in;
  my $json = JSON->new();
  $json->allow_singlequote();
  
  my $models_obj = Models->new();
  my $bg = $models_obj->get_model_bg($in->query('model_id'));
  return_html(to_json({
    image => $system->config->get('titlesbg_url') . '/' . $bg . '.jpg'
  }));
  $system->stop;
}

1;
