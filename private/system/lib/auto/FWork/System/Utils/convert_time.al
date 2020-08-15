# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 244 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/convert_time.al)"
sub convert_time {
  my ($direction, $time) = @_;
  return if not $direction;
  $time = time if $direction =~ /^sys2gmt|sys2usr$/;
  return if not $time;

  my ($sys_zone, $usr_zone) = (0, 0);
  
  return $time-($sys_zone*60*60) if $direction eq 'sys2gmt';
  return $time-(($sys_zone-$usr_zone)*60*60) if $direction eq 'sys2usr';
  return $time+($sys_zone*60*60) if $direction eq 'gmt2sys';
  return $time-(($usr_zone-$sys_zone)*60*60) if $direction eq 'usr2sys';
  return $time-($usr_zone*60*60) if $direction eq 'usr2gmt';
  return $time+($usr_zone*60*60) if $direction eq 'gmt2usr';
}

# end of FWork::System::Utils::convert_time
1;
