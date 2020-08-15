use strict;
use FWork::System;
use Mark;
use utf8;

sub mark {
  my $self = shift;
  my $in = $system->in;

  my $mobj = Mark->new();

  if($in->query('save')) {
    $mobj->rename_mark(
      mark_name => $in->query('mark_name'),
      mark_id => $in->query('mark_id')
    );
  }

  if($in->query('delete')) {
    $mobj->remove_mark($in->query('mark_id'));
  }
  
  if($in->query('add')) {
    $mobj->add_mark($in->query('mark_name'));
  }

  $self->{vars}->{marks} = $mobj->get_all_marks();
  

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
  $self->{vars}->{action} = 'mark';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
