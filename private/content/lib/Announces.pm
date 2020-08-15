package Announces;
use strict;
use FWork::System;
use JSON -support_by_pp;
use Digest::MD5 qw(md5_hex);
use utf8;


sub new {
  my $class = shift;
  my $self = bless({}, $class);
  $self->{announces} = $system->config->get('announces');
  $self->__load_announces_file();
  return $self;
}

sub __load_announces_file {
  my $self = shift;

  if( -e $self->{announces}) {
    my $js;
    open(ifl, '<'. $self->{announces});
    while(my $l = <ifl>) {
      $js .= $l;
    }
    close(ifl);
    $self->{announces_base} = from_json($js);
  } else {
    $self->{announces_base} = {};
    open(ifl, '>'. $self->{announces});
    print ifl to_json($self->{announces_base});
    close(ifl);
  }
}

sub create_announce {
  my $self = shift;
  my $in = {
    name => undef,
    body => undef,
    path => undef,
    item => undef,
    issue_id => undef,
    @_
  };
  my $aid = $self->get_id();
  $in->{ctime} = time();
  $self->{announces_base}->{$in->{issue_id}}->{$aid} = $in;
  $self->__save_base();
  return $aid;
}

sub get_id {
  my $self = shift;
  return uc(md5_hex(localtime() . rand()));
}

sub __save_base {
  my $self = shift;

  open(ifl, '>'. $self->{announces});
  print ifl to_json($self->{announces_base});
  close(ifl);

}

sub get_announces {
  my $self = shift;
  my $issue_id = shift;

  return $self->{announces_base}->{$issue_id};
}

sub get_announces_page {
  my $self = shift;
  my $in = {
    path => undef,
    item => undef,
    @_
  };

  return undef if not $in->{path};
  my $anns;
  foreach my $iid (keys %{$self->{announces_base}}) {
    foreach my $aid (keys %{$self->{announces_base}->{$iid}}) {
      if($in->{item}) {
        if($self->{announces_base}->{$iid}->{$aid}->{item} eq $in->{item} 
          and $self->{announces_base}->{$iid}->{$aid}->{path} eq $in->{path}) {
          push @$anns, $self->{announces_base}->{$iid}->{$aid};
        }
      } else {
        if($self->{announces_base}->{$iid}->{$aid}->{path} eq $in->{path}) {
          push @$anns, $self->{announces_base}->{$iid}->{$aid};
        }
      }
    }
  }
  my $ret;
  foreach my $ann (sort {$a->{ctime} <=> $b->{ctime}} @$anns) {
    push @$ret, $ann;
  }
  return $ret;
}


sub delete_announce {
  my $self = shift;
  my $issue_id = shift;
  my $announce_id = shift;

  delete $self->{announces_base}->{$issue_id}->{$announce_id};
  $self->__save_base();
}

sub save_announce {
  my $self = shift;
  my $in = {
    body => undef,
    name => undef,
    path => undef,
    item => undef,
    issue_id => undef,
    announce_id => undef,
    ctime => undef,
    @_
  };
  $self->{announces_base}->{$in->{issue_id}}->{$in->{announce_id}} = $in;
  $self->__save_base();
}

sub render_body {
  my $self = shift;
  my $body = shift;

  $body =~ s/\n//g;
  $body =~ s/\[CENTER_IMG=(.+?)\]/<div style="text-align:center;width:100%;padding-bottom:15px;"><img src="$1" class="img-thumbnail"><\/div>/g;
  $body =~ s/\[CENTER_IMG_PLAIN=(.+?)\]/<div style="text-align:center;width:100%;padding-bottom:15px;"><img src="$1" class="img-thumbnail" style="border:0px;"><\/div>/g;
  $body =~ s/\[HEADER=(.+?)\]/<h3>$1<\/h3>/g;
  $body =~ s/\[PARAGRAPH=(.+?)\]/<p class="text-justify" style="font-size:15px;">$1<\/p>/g;
  $body =~ s/\[PARAGRAPH_LEAD=(.+?)\]/<p class="text-justify lead">$1<\/p>/g;
  $body =~ s/\[QUOTE=(.+?)\]/<blockquote><p><span class="glyphicon glyphicon-pushpin" aria-hidden="true"><\/span>&nbsp;&nbsp;&nbsp;<span style="color:#aaa">$1<\/span><\/p><\/blockquote>/g;
  $body =~ s/\[QUOTE_PLAIN=(.+?)\]/<blockquote style="font-size:14px;color:#777">$1<\/blockquote>/g;
  $body =~ s/<<(.+?)>>/&laquo;$1&raquo;/g;
  # $body =~ s/SS=(.+?)\s/&sect;$1 /g;

  return $body;
}

sub date_prepare {
  my $self = shift;
  my $date = shift;

  my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($date);
  return sprintf("%02d.%02d.%4d %02d:%02d:%02d", $mday, $mon + 1, $year + 1900, $hour, $min, $sec);
}

1;
