use strict;
use FWork::System;
use Category;
use Brand;
use Mark;
use Models;
use utf8;

sub add_models {
  my $self = shift;
  my $in = $system->in;
  
  if($in->query('add')) {
#     $system->dump($in);
    my $model_obj = Models->new();
    my $model_id = $model_obj->add_model(
      model_desc => $in->query('model_desc'),
      model_char => $in->query('model_char'),
      model_common => $in->query('model_common'),
      model_name => $in->query('model_name'),
      model_year => $in->query('model_year'),
      model_flag => 'N'    
    );
    foreach my $c (@{$in->{query}->{categories}}) {
      $model_obj->link_model(
        source_id => $c,
        target_id => $model_id,
        source_table => 'categories',
        target_table => 'models'
      );
    }
    $model_obj->link_model(
      source_id => $in->query('brands'),
      target_id => $model_id,
      source_table => 'brands',
      target_table => 'models'
    );
    $model_obj->link_model(
      source_id => $in->query('marks'),
      target_id => $model_id,
      source_table => 'marks',
      target_table => 'models'
    );
    $system->out->redirect('/cgi-bin/index.cgi?action=edit_models&pkg=content:admins&model_id=' . $model_id);
    $system->stop;
  }

  $self->{vars}->{cats} = Category->new()->get_all_categories();
  $self->{vars}->{brands} = Brand->new()->get_all_brands();
  $self->{vars}->{marks} = Mark->new()->get_all_marks();
  
  $self->{vars}->{action} = 'models';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
