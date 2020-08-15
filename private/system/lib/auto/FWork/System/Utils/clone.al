# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 214 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/clone.al)"
sub clone {
  my $data = shift;
  return $data if not ref $data;

  require Storable;
  return Storable::dclone($data);
}

# end of FWork::System::Utils::clone
1;
