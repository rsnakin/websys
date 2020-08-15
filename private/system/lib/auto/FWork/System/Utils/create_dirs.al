# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 317 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/create_dirs.al)"
sub create_dirs {
  my ($path, $mode) = @_;
  return if false($path);
  $mode ||= 0777;

  my @dirs = split(/\//, $path); 
  my $newpath = "";
  foreach my $dir (@dirs) {
    if (not -d $newpath.$dir) {
      mkdir $newpath.$dir, $mode || die "Can't create [ $newpath$dir ]: $!!";
    }
    $newpath .= "$dir/";
  }

  return 1;
}

# end of FWork::System::Utils::create_dirs
1;
