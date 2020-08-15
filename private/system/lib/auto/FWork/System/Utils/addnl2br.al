# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 191 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/addnl2br.al)"
sub addnl2br {
  my @strings = @_;
  return if not @strings;
  foreach (@strings) { next if not defined; s/<br\/?>/<br\/>\n/sg; }
  return wantarray ? @strings : $strings[0];
}

# end of FWork::System::Utils::addnl2br
1;
