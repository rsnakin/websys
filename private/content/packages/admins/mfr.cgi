use strict;
use FWork::System;
use Brand;
use utf8;

sub mfr {
  my $self = shift;
  my $in = $system->in;

  my $bobj = Brand->new();

  if($in->query('save')) {
    $bobj->rename_brand(
      brand_name => $in->query('brand_name'),
      brand_id => $in->query('brand_id')
    );
  }

  if($in->query('delete')) {
    $bobj->remove_brand($in->query('brand_id'));
  }
  
  if($in->query('add')) {
    $bobj->add_brand($in->query('brand_name'));
  }

  $self->{vars}->{brands} = $bobj->get_all_brands();
  

#   $system->dump($self->{vars}->{brands});
  
#   
# 
# 
#   my $cats = $cobj->get_all_gategories();
#   my $links = $cobj->get_all_links();
# #   $system->dump($links);
#   foreach my $c (sort {$a->{brand_name} cmp $b->{brand_name}} @$cats) {
#     if($c->{brand_source} eq 'MASTER') {
#       foreach my $c1 (sort {$a->{brand_name} cmp $b->{brand_name}} @$cats) {
#         my $linked;
#         next if $c1->{brand_source} eq 'MASTER'; 
#         foreach my $l (@$links) {
#           if($l->{master_brand_id} == $c->{brand_id} and $l->{brand_id} == $c1->{brand_id}) {
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
  $self->{vars}->{action} = 'mfr';
  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
