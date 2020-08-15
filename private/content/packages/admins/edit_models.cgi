use strict;
use FWork::System;
use Category;
use Brand;
use Mark;
use Models;
use utf8;

sub edit_models {
  my $self = shift;
  my $in = $system->in;
  
  my $model_obj = Models->new();
  if($in->query('save')) {
    $model_obj->update_model(
      model_id   => $in->query('model_id'),
      model_desc => $in->query('model_desc'),
      model_name => $in->query('model_name'),
      model_year => $in->query('model_year'),
      model_flag => $in->query('model_flag'),
      model_char => $in->query('model_char'),
      model_common => $in->query('model_common')
    );
    $model_obj->unlink_model($in->query('model_id'));
    foreach my $c (@{$in->{query}->{categories}}) {
      $model_obj->link_model(
        source_id => $c,
        target_id => $in->query('model_id'),
        source_table => 'categories',
        target_table => 'models'
      );
    }
    foreach my $c (@{$in->{query}->{brands}}) {
      $model_obj->link_model(
        source_id => $c,
        target_id => $in->query('model_id'),
        source_table => 'brands',
        target_table => 'models'
      );
    }
    $model_obj->link_model(
      source_id => $in->query('marks'),
      target_id => $in->query('model_id'),
      source_table => 'marks',
      target_table => 'models'
    );
  }

  $self->{vars}->{model} = $model_obj->get_model($in->query('model_id'));
  $self->{vars}->{model_links} = $model_obj->get_model_links($in->query('model_id'));
  
  $self->{vars}->{cats} = Category->new()->get_all_categories();
  $self->{vars}->{brands} = Brand->new()->get_all_brands();
  $self->{vars}->{marks} = Mark->new()->get_all_marks();
  
  foreach my $c (@{$self->{vars}->{cats}}) {
    foreach my $mc (@{$self->{vars}->{model_links}->{categories}}) {
      if($c->{category_id} == $mc) {
        $c->{selected} = 'selected';
      }
    }
  }

  foreach my $b (@{$self->{vars}->{brands}}) {
    foreach my $mb (@{$self->{vars}->{model_links}->{brands}}) {
      if($b->{brand_id} == $mb) {
        $b->{selected} = 'selected';
      }
    }
  }

  foreach my $m (@{$self->{vars}->{marks}}) {
    foreach my $mm (@{$self->{vars}->{model_links}->{marks}}) {
      if($m->{mark_id} == $mm) {
        $m->{selected} = 'selected';
      }
    }
  }

#   $system->dump($self->{vars});
  
  
  $self->{vars}->{action} = 'models';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
