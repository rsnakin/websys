# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 454 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/match.al)"
# match two hashes (order doesn't matter) or plain variables
# returns 1 if their values (and keys) are identical, 0 otherwise
# returns 1 if both vars are not defined or empty
sub match {
  my ($var1, $var2) = @_;

  # two parameters and not defined, so they match
  return 1 if not defined $var1 and not defined $var2;

  # one is a ref, another is not = no match
  return 0 if not ref $var1 and ref $var2;
  return 0 if not ref $var2 and ref $var1;

  # refs on different things, they don't match
  return 0 if (ref $var1 and ref $var2) and (ref $var1 ne ref $var2);

  if (ref $var1 eq 'HASH') {
    # different number of keys in the hash - they don't match
    return 0 if scalar(keys %$var1) != scalar(keys %$var2);

    foreach my $key (%$var1) {
      if (not ref $var1->{$key}) {
        return 0 if $var1->{$key} ne $var2->{$key};
      } elsif (not match($var1->{$key}, $var2->{$key})) {
        return 0;
      }
    }
  } elsif (ref $var1 eq 'ARRAY') {
    # different number of elements in array - they don't match
    return 0 if scalar @$var1 != scalar @$var2;
    
    for (my $i = 0; $i <= $#{$var1}; $i++) {
      if (not ref $var1->[$i]) {
        return 0 if $var1->[$i] ne $var2->[$i];
      } elsif (not match($var1->[$i], $var2->[$i])) {
        return 0;
      }
    }
  } elsif (not ref $var1) {
    return 0 if $var1 ne $var2;
  } else {
    # a ref that we don't support (we only support HASH and ARRAY)
    return 0;
  }

  return 1;
}

# end of FWork::System::Utils::match
1;
