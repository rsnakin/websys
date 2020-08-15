# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 518 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/nl2space.al)"
sub nl2space {
  my @strings = @_;
  return if not @strings;
  foreach (@strings) { next if not defined; s/\n\r?/ /sg; }
  return wantarray ? @strings : $strings[0];
}

# end of FWork::System::Utils::nl2space
1;
