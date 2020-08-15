# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 92 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/time_elapsed.al)"
sub time_elapsed {
  my $elapsed = shift;
  return '0 secs' if not $elapsed;
  
  my $hours = int($elapsed / 60 / 60);
  my $mins = int($elapsed / 60) - $hours*60;
  # seconds could be fractional, so we use int on their value too
  my $secs = int($elapsed - (int($elapsed / 60)*60));

  my $msg;
  if ($hours > 0) {
    $msg .= "$hours hour".($hours != 1 ? 's' : '');
    $msg .= ' ' if $mins > 0 or $secs > 0;
  }
  if ($mins > 0 or ($hours > 0 and $secs > 0)) {
    $msg .= "$mins min".($mins != 1 ? 's' : '');
    $msg .= ' ' if $secs > 0;
  }
  if ($secs > 0) {
    $msg .= "$secs sec".($secs != 1 ? 's' : '');
  }
  
  return $msg;
}

# end of FWork::System::Utils::time_elapsed
1;
