# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 260 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/cp.al)"
sub cp {
  my ($source, $target) = @_;

  return if false($source) or false($target);

  # opening files and putting them in the binmode (for Windows)
  my ($s, $t);

  if (ref $source) {
    $s = $source;
    if (not $s->opened) {
      $s->open('r') || die "Can't open file [ " . $s->name . " ] for reading: $!";
    } elsif ($s->mode ne 'r') {
      die "Source file should be in a read mode!";
    }
  } else {
    $s = FWork::System::File->new($source, 'r') || die "Can't open file [ $source ] for reading: $!";
  }

  if (ref $target) {
    $t = $target;
    if (not $t->opened) {
      $t->open('w') || die "Can't open file [ " . $s->name . " ] for writing: $!";
    } elsif ($t->mode eq 'r') {
      die "Target file should be in a write, append or update mode!";
    }
  } else {
    $t = FWork::System::File->new($target, 'w') || die "Can't open file [ $target ] for writing: $!";
  }

  binmode $s->handle;
  binmode $t->handle;
  
  # initializing the read counter
  my $read = 0;
  # getting size of the source file
  my ($mode, $size) = (stat($s->name))[2, 7];

  # copying process
  my ($buffer, $to_read, $left);
  while ($read < $size) {
    $left = $size - $read;
    $to_read = ($left > 4096 ? 4096 : $left);
    sysread $s->handle, $buffer, $to_read;
    syswrite $t->handle, $buffer, length($buffer);
    $read += $to_read;
  }

  # done copying, closing files
  $t->close;
  $s->close;

  chmod ($mode & 0777), $t->name;

  return $s, $t;
}

# end of FWork::System::Utils::cp
1;
