# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 448 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/in_array.al)"
sub in_array {
  my ($key, @array) = @_;
  return undef if not defined $key or not @array;
  foreach (@array) { return 1 if $_ eq $key }
}

# end of FWork::System::Utils::in_array
1;
