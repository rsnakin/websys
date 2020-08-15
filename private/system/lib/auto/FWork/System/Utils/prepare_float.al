# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 181 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/prepare_float.al)"
sub prepare_float {
  my $value = shift @_;
  return if not defined $value;

  $value =~ s/,/\./g;
  $value =~ s/[^\d\.]//g;

  return $value;
}

# end of FWork::System::Utils::prepare_float
1;
