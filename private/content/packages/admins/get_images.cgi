use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use JSON -support_by_pp;
use Models;

sub get_images {
  my $self = shift;
  my $in = $system->in;
  my $json = JSON->new();
  $json->allow_singlequote();
  
  my $models_obj = Models->new();
  
  if($in->query('image_name')) {
    if($in->query('sort')) {
      my $model_images = $models_obj->get_model_images($in->query('model_id'));
#       $models_obj->remove_images($in->query('model_id'));
      my $image;
      foreach my $i (@$model_images) {
        next if $i->{image_name} ne $in->query('image_name');
        $image = $i;
        last;
      }
      my $new_sort_id;
      my $old_sort_id = $image->{sort_id};
      if($in->query('direct') eq 'down') {
        $new_sort_id = $old_sort_id + 1;
      } else {
        $new_sort_id = $old_sort_id - 1;
      }
      my $ok;
      foreach my $i (@$model_images) {
        if($i->{sort_id} == $new_sort_id) {
          $i->{sort_id} = $old_sort_id;
          $ok = 1;
          last;
        }
      }
      if($ok == 1) {
        foreach my $i (@$model_images) {
          next if $i->{image_name} ne $in->query('image_name');
          $i->{sort_id} = $new_sort_id;
          last;
        }
        $models_obj->remove_images($in->query('model_id'));
        foreach my $i (sort{$a->{sort_id} <=> $b->{sort_id}} @$model_images) {
          $models_obj->save_image(
            image_name => $i->{image_name},
            model_id => $in->query('model_id'),
            image_width => $i->{image_width},
            image_height => $i->{image_height}
          );
        }
      }
    }
    if($in->query('remove')) {
      my $model_images = $models_obj->get_model_images($in->query('model_id'));
      $models_obj->remove_images($in->query('model_id'));
      foreach my $i (@$model_images) {
        if($i->{image_name} ne $in->query('image_name')) {
          $models_obj->save_image(
            image_name => $i->{image_name},
            model_id => $in->query('model_id'),
            image_width => $i->{image_width},
            image_height => $i->{image_height}
          );
        } else {
          unlink($system->config->get('images_path'). '/' . $in->query('image_name') . '/a.jpg');
          unlink($system->config->get('images_path'). '/' . $in->query('image_name') . '/b.jpg');
          unlink($system->config->get('images_path'). '/' . $in->query('image_name') . '/c.jpg');
          unlink($system->config->get('images_path'). '/' . $in->query('image_name') . '/d.jpg');
          rmdir($system->config->get('images_path'). '/' . $in->query('image_name'));
        }
      }
    }
  }
  
  $self->{vars}->{images} = $models_obj->get_model_images($in->query('model_id'));
  $self->{vars}->{base_url} = $system->config->get('images_url');
#   $system->dump($self->{vars}->{images});
  my $html;
  $html = $self->_template()->parse($self->{vars}) if $self->{vars}->{images};
  return_html(to_json({
    html => $html
  }));
  $system->stop;
}

1;
