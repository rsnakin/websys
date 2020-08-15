package Structure;
use strict;
use FWork::System;
use JSON -support_by_pp;
use utf8;

my $types = {
  1 => 'issue',
  2 => 'links'
};

sub new {
  my $class = shift;
  my $self = bless({}, $class);
  $self->{structure_file} = $system->config->get('structure_file');
  $self->{structure} = $self->__get_structure();
  return $self;
}

sub get_structure {
  my $self = shift;
  return $self->{structure};
}

sub __get_structure {
  my $self = shift;
  my $json = JSON->new();
  $json->allow_singlequote();
  my $structure;
  my $menu;

  open(sfl, '<' . $self->{structure_file});
  while(my $l = <sfl>) {
    $structure .= $l;
  }
  close(sfl);
  my $jstructure = from_json($structure);
  $self->{jstructure} = $jstructure;
  foreach my $url (sort {$jstructure->{$a}->{sort_id} <=> $jstructure->{$b}->{sort_id}} keys %$jstructure) {
    my $item = {
      sort_id => $jstructure->{$url}->{sort_id},
      name => $jstructure->{$url}->{name},
      path => '/' . $url
    };
    if($jstructure->{$url}->{type} eq '3') {
      foreach my $itm (sort {$jstructure->{$url}->{items}->{$a}->{sort_id} <=> $jstructure->{$url}->{items}->{$b}->{sort_id}}keys %{$jstructure->{$url}->{items}}) {
        $jstructure->{$url}->{items}->{$itm}->{path} = '/' . $url . '/' . $itm;
        push @{$item->{items}}, $jstructure->{$url}->{items}->{$itm};
      }
    }
    push @$menu, $item;
  }
  return $menu;
}

sub get_type {
  my $self = shift;
  my $tail_id = shift;
  my $text_id = shift;
  my $type;
  
  if($tail_id) {
    $type = $self->{jstructure}->{$tail_id}->{items}->{$text_id}->{type};
  } else {
    $type = $self->{jstructure}->{$text_id}->{type};
  }

  return $types->{$type};
}

1;
