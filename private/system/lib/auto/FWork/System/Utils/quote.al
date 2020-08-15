# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 601 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/quote.al)"
sub quote {
  my ($string, $start, $end, $no_border) = @_;
  $start = "'" if false($start);
  $end = $start if false($end);
  if (false($string)) {
    return if $no_border; 
    return $start.$end if not $no_border;
  }

  # escaping quoting characters and the escaping '\' itself inside the string
  $string =~ s/([\\$start$end])/$1 eq '\\' ? "\\\\" : "\\$1"/sge;

  return ($no_border ? '' : $start) . $string .  ($no_border ? '' : $end);
}

# end of FWork::System::Utils::quote
1;
