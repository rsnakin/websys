use strict;
use FWork::System;
# use Issues;
use Structure;
use utf8;
use JSON -support_by_pp;

sub carousel {
  my $self = shift;
  my $in = $system->in;

  my $carousel_file = $system->config->get('carousel_file');
  my $carousel_url = $system->config->get('carousel_url');
  my $carousel_imgs = $system->config->get('carousel_imgs');

  my $structure = Structure->new()->{jstructure};

  # $system->dump($structure);

  $self->{vars}->{page} = 'carousel';

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

  if($in->query('sort')) {
    my $sort_id = $carousel->{$in->query('cid')}->{sort_id};
    my $n_sort_id = $carousel->{$in->query('cid')}->{sort_id};
    if($in->query('sort') eq 'up') {
      $n_sort_id --;
    } else {
      $n_sort_id ++;
    }
    foreach my $cid (sort {$carousel->{$a}->{sort_id} <=> $carousel->{$b}->{sort_id}} keys %$carousel) {
      if($carousel->{$cid}->{sort_id} == $n_sort_id) {
        $carousel->{$cid}->{sort_id} = $sort_id;
        $carousel->{$in->query('cid')}->{sort_id} = $n_sort_id;
        last;
      }
    }
    open(cfl, '>' . $carousel_file);
    print cfl to_json($carousel);
    close(cfl);
    $system->out->redirect('/cgi-bin/index.cgi?pkg=content:a&action=carousel');
    $system->stop;
  }

  if($in->query('delete_carousel_id')) {
    unlink($carousel_imgs . '/' . $carousel->{$in->query('delete_carousel_id')}->{file});
    delete $carousel->{$in->query('delete_carousel_id')};
    my $sort_id = 1;
    foreach my $cid (sort {$carousel->{$a}->{sort_id} <=> $carousel->{$b}->{sort_id}} keys %$carousel) {
      $carousel->{$cid}->{sort_id} = $sort_id;
      $sort_id ++;
    }
    open(cfl, '>' . $carousel_file);
    print cfl to_json($carousel);
    close(cfl);
    $system->out->redirect('/cgi-bin/index.cgi?pkg=content:a&action=carousel');
    $system->stop;
  }

  foreach my $cid (sort {$carousel->{$a}->{sort_id} <=> $carousel->{$b}->{sort_id}} keys %$carousel) {
    $carousel->{$cid}->{file} = $carousel_url . '/' . $carousel->{$cid}->{file};
    $carousel->{$cid}->{cid} = $cid;
    $carousel->{$cid}->{t_path} = $structure->{$carousel->{$cid}->{path}}->{name};
    $carousel->{$cid}->{t_item} = $structure->{$carousel->{$cid}->{path}}->{items}->{$carousel->{$cid}->{item}}->{name};
    push @{$self->{vars}->{carousel}}, $carousel->{$cid};
  }

  # $system->dump($self->{vars}->{carousel});


  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
