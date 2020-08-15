use strict;
use FWork::System;
use Category;
use utf8;

sub category {
  my $self = shift;
  my $in = $system->in;

  my $cobj = Category->new();

  if($in->query('save')) {
    $cobj->rename_category(
      category_name => $in->query('category_name'),
      category_id => $in->query('category_id')
    );
  }

  if($in->query('delete')) {
    $cobj->remove_category($in->query('category_id'));
  }
  
  if($in->query('add')) {
    $cobj->add_category($in->query('category_name'));
  }

  $self->{vars}->{cats} = $cobj->get_all_categories();
  

#   $system->dump($cats);
  
#   
# 
# 
#   my $cats = $cobj->get_all_gategories();
#   my $links = $cobj->get_all_links();
# #   $system->dump($links);
#   foreach my $c (sort {$a->{category_name} cmp $b->{category_name}} @$cats) {
#     if($c->{category_source} eq 'MASTER') {
#       foreach my $c1 (sort {$a->{category_name} cmp $b->{category_name}} @$cats) {
#         my $linked;
#         next if $c1->{category_source} eq 'MASTER'; 
#         foreach my $l (@$links) {
#           if($l->{master_category_id} == $c->{category_id} and $l->{category_id} == $c1->{category_id}) {
#             $linked = 1;
# #             last;
#           }
#         }
# #         $system->dump($c) if $linked;
# #         $linked  = 1;
#         push @{$c->{mycats}}, {cat => $c1, linked => $linked};
#       }
#     push @{$self->{vars}->{master}}, $c ;
#     }
#   }
# #   $system->dump($self->{vars}->{master});
# 
  $self->{vars}->{action} = 'category';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
