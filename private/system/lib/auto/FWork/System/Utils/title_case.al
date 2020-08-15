# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 685 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/title_case.al)"
sub title_case {
  my $string = shift;
  return $string if false($string);

  # generating a unique string with 20 lower case letters, which we will use 
  # to mark artifically inserted spaces, which we will need to cut out at the end
  my $cut_id;
  while (not defined $cut_id or $string =~ /$cut_id/) {
     $cut_id = create_random(20, letters_lc => 1);
  }
  
  my $split_chr = quotemeta('.,!-/()\\[]"');
  
  $string =~ s/([$split_chr])(\S)/$1$cut_id $2/g;
  my @words = split(/\s+/, $string);
  
  for (my $i = 0; $i < scalar @words; $i++) {
    # if the word contains a number then we think this is a postcode or
    # something similar and keep the original case of the word
    next if $words[$i] =~ /\d/;
    $words[$i] = ucfirst(lc($words[$i]));      
  }
  
  $string = join(' ', @words);
  $string =~ s/$cut_id\s//g;
  
  return $string;
}

# end of FWork::System::Utils::title_case
1;
