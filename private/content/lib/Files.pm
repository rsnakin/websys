package Files;
use strict;
use File::stat;
use utf8;

sub new {
  my $class = shift;
  my $self = bless({}, $class);
  $self->{folder} = shift;
  return undef if not $self->{folder};
  return $self;
}

sub get_files {
  my $self = shift;

  my $dir = $self->{folder};
  

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

  my $files;
  opendir(my $dh, $dir) || return undef;
  while (my $f = readdir $dh) {
    my $data = stat($dir . '/' . $f);
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($data->ctime);
    push @$files, {
      path => $dir . '/' . $f,
      name => $f,
      ctime => $data->ctime,
      size => sprintf("%.3fk", $data->size / 1024.),
      time_str => sprintf("%02d.%02d.%4d %02d:%02d", $mday, $mon + 1, $year + 1900, $hour, $min)
    } if $f ne '..' and $f ne '.';
  }
  closedir $dh;

  return $files;
}

sub get_files_short {
  my $self = shift;

  my $dir = $self->{folder};
  
  my $files;
  opendir(my $dh, $dir) || return undef;
  while (my $f = readdir $dh) {
    my $data = stat($dir . '/' . $f);
    my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($data->ctime);
    push @$files, {
      name => $f,
      ctime => $data->ctime
    } if $f ne '..' and $f ne '.' and $f ne 'prev';
  }
  closedir $dh;

  return $files;
}


1;
