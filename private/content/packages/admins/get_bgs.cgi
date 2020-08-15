use strict;
use FWork::System;
use FWork::System::Ajax qw(&return_html);
use utf8;
use JSON -support_by_pp;
use TitlesBg;

sub get_bgs {
  my $self = shift;
  my $in = $system->in;
  my $json = JSON->new();
  $json->allow_singlequote();
  
  my $obj = TitlesBg->new();
  
  $self->{vars}->{bgs} = $obj->get_all_bg();
  $self->{vars}->{base_url} = $system->config->get('titlesbg_url');
  $self->{vars}->{rand} = rand();
  my $html;
  $html = $self->_template()->parse($self->{vars}) if $self->{vars}->{bgs};
  return_html(to_json({
    html => $html
  }));
  $system->stop;
}

1;
