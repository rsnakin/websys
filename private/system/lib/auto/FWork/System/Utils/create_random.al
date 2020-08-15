# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 334 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/create_random.al)"
sub create_random {
  my ($length) = shift @_;
  my $options = {
    letters_lc => undef, # use lower case letters
    letters_uc => undef, # use upper case letters
    digits     => undef, # use digits
    @_
  };
  $length = 20 if not $length;

  my $no_options = 1;
  foreach (qw(letters_lc letters_uc digits)) {
    if ($options->{$_}) {
      $no_options = undef;
      last;
    }
  }
  
  my @chars = ();
  push @chars, ('a'..'z') if $no_options or $options->{letters_lc};
  push @chars, ('A'..'Z') if $no_options or $options->{letters_uc};
  push @chars, (0..9) if $no_options or $options->{digits};

  my $string;

  for (my $i = 0; $i < $length; $i++) {
    $string .= $chars[ int(rand(@chars)) ];
  }
  return $string;
}

# end of FWork::System::Utils::create_random
1;
