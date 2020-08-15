use strict;
use FWork::System;
use utf8;
use Structure;
use Announces;
use Issues;
use JSON -support_by_pp;


sub index {
  my $self = shift;
  my $in = $system->in;

  $self->{vars}->{page} = 'index';
  my $sobj = Structure->new();
  $self->{vars}->{menu} = $sobj->get_structure();

  my $structure = $sobj->{jstructure};


  my $carousel_file = $system->config->get('carousel_file');
  my $carousel_url = $system->config->get('carousel_url');

  my $crsl;
  my $carousel;

  if( -e $carousel_file ) {
    open(cfl, '<' . $carousel_file);
    while(my $l = <cfl>) {
      $crsl .= $l;
    }
    close(cfl);
    $carousel = from_json($crsl);
  }

  foreach my $cid (sort {$carousel->{$a}->{sort_id} <=> $carousel->{$b}->{sort_id}} keys %$carousel) {
    if($carousel->{$cid}->{item} ne 'null') {
      $carousel->{$cid}->{url} = '/' . $carousel->{$cid}->{path} . '/' . $carousel->{$cid}->{item};
    } else {
      $carousel->{$cid}->{url} = '/' . $carousel->{$cid}->{path};
    }
    if($carousel->{$cid}->{sort_id} == 1) {
      $carousel->{$cid}->{active} = 'active';
    }
    $carousel->{$cid}->{cnt} = $carousel->{$cid}->{sort_id} - 1;
    $carousel->{$cid}->{file} = $carousel_url . '/' . $carousel->{$cid}->{file};
    $carousel->{$cid}->{cid} = $cid;
    $carousel->{$cid}->{t_path} = $structure->{$carousel->{$cid}->{path}}->{name};
    $carousel->{$cid}->{t_item} = $structure->{$carousel->{$cid}->{path}}->{items}->{$carousel->{$cid}->{item}}->{name};
    push @{$self->{vars}->{carousel}}, $carousel->{$cid};
  }

  my $aobj = Announces->new();
  my $iobj = Issues->new();
  $self->{vars}->{main_announce} = ($aobj->get_announces_page(path => '__main'))->[0];
  $self->{vars}->{main_announce}->{link} = $iobj->get_issue_url($self->{vars}->{main_announce}->{issue_id});
  $self->{vars}->{main_announce}->{body} = $aobj->render_body($self->{vars}->{main_announce}->{body});

  my $anns = $aobj->get_announces_page(path => '__main_lenta');
  my $cnt = 0;
  foreach my $ann (@$anns) {
    if($cnt > 1) {
      $ann->{next_line} = 'yes';
      $cnt = 0;
    } else {
      $cnt++;
    }
    $ann->{link} = $iobj->get_issue_url($ann->{issue_id});
    $ann->{body} = $aobj->render_body($ann->{body});
    push @{$self->{vars}->{announces}}, $ann;
  }
  # $system->dump($iobj);
  # $system->dump($self->{vars}->{announces});

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
