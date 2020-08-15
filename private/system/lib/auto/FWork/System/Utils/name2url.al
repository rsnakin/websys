# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 502 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/name2url.al)"
sub name2url { 
  my $name = shift;
  return '' if false($name);
  # removing all charachters that are not letters, digits, points
  $name =~ s/[^\w\.\d]/_/g;
  # also forcing lower case
  return lc($name);
}

# end of FWork::System::Utils::name2url
1;
