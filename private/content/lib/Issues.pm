package Issues;
use strict;
use FWork::System;
use JSON -support_by_pp;
use Digest::MD5 qw(md5_hex);
use File::stat;
use utf8;

my $types = {
  1 => 'issue',
  2 => 'links'
};

sub new {
  my $class = shift;
  my $self = bless({}, $class);
  $self->{issues_file} = $system->config->get('issues_file');
  $self->{issues_folder} = $system->config->get('issues_folder');
  $self->{issue_img_path} = $system->config->get('issue_img_path');
  $self->{issue_img_url} = $system->config->get('issue_img_url');

  $self->__load_issues_file();
  return $self;
}

sub render_body {
  my $self = shift;
  my $body = shift;

  $body =~ s/\n/-=BR=-/g;
  my $img_modal = 
    '<div class="modal fade" id="-=IMG_ID=-" tabindex="-1" role="dialog" aria-labelledby="ddTopicLabel">
      <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="myModalLabel"></h4>
          </div>
          <div class="modal-body">
            <img src="-=IMG=-" class="img-responsive">
          </div>
        </div>
      </div>
    </div>';

  while($body =~ /\[MODAL_IMG=(.+?)\]/) {
    my $img = $1;
    $body .= $img_modal;
    my $rand = uc(md5_hex(rand()));
    $body =~ s/-=IMG_ID=-/$rand/ge;
    $body =~ s/-=IMG=-/$img/ge;
    $body =~ s/\[MODAL_IMG=(.+?)\]/<a class="prevImg" data-toggle="modal" data-target="#$rand" style="cursor:pointer;"><img src="$img" class="img-thumbnail" width="100" height="100"><\/a>/;
  }
  while($body =~ /\[CODE=\:\<(.+?)\>\:(.+?)\:=\]/) {
    my $cName = $1;
    my $cCode = $2;
    my $id = my $rand = uc(md5_hex(rand()));
    $cCode =~ s/\</&lt;/g;
    $cCode =~ s/\>/&gt;/g;
    $body =~ s/\[CODE=\:\<(.+?)\>\:(.+?)\:=\]/<div class="codeBlock" pid="$id">$cName<\/div><div id="$id" class="codeBlockH"><pre class="cCode"><code class="language-c">$cCode<\/code><\/pre><\/div>/;
  }

  $body =~ s/\[CENTER_IMG=(.+?)\]/<div style="text-align:center;width:100%;padding-bottom:15px;"><img src="$1" class="img-thumbnail"><\/div>/g;
  $body =~ s/\[CENTER_IMG_PLAIN=(.+?)\]/<div style="text-align:center;width:100%;padding-bottom:15px;"><img src="$1" style="display: inline-block;" class="img-responsive"><\/div>/g;
  $body =~ s/\[HEADER=(.+?)\]/<h3>$1<\/h3>/g;
  $body =~ s/\[PARAGRAPH=(.+?)\]/<p class="text-justify" style="font-size:15px;">$1<\/p>/g;
  $body =~ s/\[PARAGRAPH_LEAD=(.+?)\]/<p class="text-justify" style="font-size:16px;">$1<\/p>/g;
  $body =~ s/\[QUOTE=(.+?)\]/<blockquote><p><span class="glyphicon glyphicon-pushpin" aria-hidden="true"><\/span>&nbsp;&nbsp;&nbsp;<span style="font-size:16px;color:#333">$1<\/span><\/p><\/blockquote>/g;
  $body =~ s/\[QUOTE_PLAIN=(.+?)\]/<blockquote style="font-size:14px;color:#777">$1<\/blockquote>/g;
  $body =~ s/<<(.+?)>>/&laquo;$1&raquo;/g;
  # $body =~ s/SS=(.+?)\s/&sect;$1 /g;
  $body =~ s/-=BR=-/\n/g;

  return $body;
}

sub delete_issue {
  my $self = shift;
  my $issue_id = shift;

  delete $self->{issues_base}->{$issue_id};
  $self->__save_base();

  unlink($self->{issues_folder} . '/' . $issue_id);
}

sub get_issue_url {
  my $self = shift;
  my $issue_id = shift;

  my $issue = $self->{issues_base}->{$issue_id};
  return '/' . $issue->{path} . '/' . $issue->{item};
}

sub date_prepare {
  my $self = shift;
  my $date = shift;

  my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($date);
  return sprintf("%02d.%02d.%4d %02d:%02d", $mday, $mon + 1, $year + 1900, $hour, $min);
}

sub get_issue {
  my $self = shift;
  my $issue_id = shift;
  my $json = JSON->new();
  $json->allow_singlequote();

  open(ifl, '<' . $self->{issues_folder} . '/' . $issue_id);
  my $body;
  while(my $l = <ifl>) {
    $body .= $l;
  }
  close(ifl);

  return $body;
}

sub check_name {
  my $self = shift;
  my $name = shift;

  foreach my $id (keys %{$self->{issues_base}}) {
    if($self->{issues_base}->{$id}->{name} eq $name) {
      return 1;
    }
  }

  return undef;
}

sub save_issue {
  my $self = shift;
  my $in = {
    body => undef,
    name => undef,
    path => undef,
    item => undef,
    issue_id => undef,
    date_time => undef,
    @_
  };
  open(ifl, '>' . $self->{issues_folder} . '/' . $in->{issue_id});
  print ifl $in->{body};
  close(ifl);

  delete $in->{body};
  $self->{issues_base}->{$in->{issue_id}} = $in;
  $self->__save_base();
}


sub create_issue {
  my $self = shift;
  my $in = {
    name => undef,
    path => undef,
    item => undef,
    issue_id => undef,
    @_
  };
  $in->{date_time} = time();
  $self->{issues_base}->{$in->{issue_id}} = $in;
  open(ifl, '>' . $self->{issues_folder} . '/' . $in->{issue_id});
  print ifl '<b></b>';
  close(ifl);
  $self->__save_base();
}

sub __save_base {
  my $self = shift;

  open(ifl, '>'. $self->{issues_file});
  print ifl to_json($self->{issues_base});
  close(ifl);

}

sub __load_issues_file {
  my $self = shift;

  if( -e $system->config->get('issues_file')) {
    my $js;
    open(ifl, '<'. $self->{issues_file});
    while(my $l = <ifl>) {
      $js .= $l;
    }
    close(ifl);
    $self->{issues_base} = from_json($js);
  } else {
    $self->{issues_base} = {};
    open(ifl, '>'. $self->{issues_file});
    print ifl to_json($self->{issues_base});
    close(ifl);
  }
}

sub get_id {
  my $self = shift;
  return uc(md5_hex(localtime() . rand()));
}

sub get_issue_imgs {
  my $self = shift;
  my $issue_id = shift;

  my $dir = $self->{issue_img_path} . '/' . $issue_id;
  my $url = $self->{issue_img_url} . '/' . $issue_id;

=pod
  0 dev      device number of filesystem
  1 ino      inode number
  2 mode     file mode  (type and permissions)
  3 nlink    number of (hard) links to the file
  4 uid      numeric user ID of file's owner
  5 gid      numeric group ID of file's owner
  6 rdev     the device identifier (special files only)
  7 size     total size of file, in bytes
  8 atime    last access time in seconds since the epoch
  9 mtime    last modify time in seconds since the epoch
 10 ctime    inode change time in seconds since the epoch (*)
 11 blksize  preferred I/O size in bytes for interacting with the
             file (may vary from file to file)
 12 blocks   actual number of system-specific blocks allocated
             on disk (often, but not always, 512 bytes each)
=cut

  opendir(my $dh, $dir) || return undef;
  while (my $f = readdir $dh) {
    my $data = stat($dir . '/' . $f);
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($data->ctime);
    push @{$self->{issue_imgs}}, {
      path => $dir . '/' . $f,
      url => $url . '/' . $f,
      name => $f,
      ctime => $data->ctime,
      size => sprintf("%.3fk", $data->size / 1024.),
      time_str => sprintf("%02d.%02d.%4d %02d:%02d", $mday, $mon + 1, $year + 1900, $hour, $min)
    } if $f ne '..' and $f ne '.';
  }
  closedir $dh;

  my $ret;
  foreach my $f (sort {$b->{ctime} <=> $a->{ctime}} @{$self->{issue_imgs}}) {
    push @$ret, $f;
  }

  return $ret;
}
1;
