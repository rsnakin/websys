# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 616 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/match_strings.al)"
sub match_strings {
  my $string1 = shift;
  my $string2 = shift;
  
  $string1 =~ s/^\s+//;
  $string1 =~ s/\s+$//;
  $string2 =~ s/^\s+//;  
  $string2 =~ s/\s+$//;
  
  # turning a string into an array and converting everything to lowercase
  my @words1 = map {lc($_)} split(/[\r\n\s]+/, $string1);
  my @words2 = map {lc($_)} split(/[\r\n\s]+/, $string2); 
  
  return 0 if not @words1 or not @words2;
  
  # We need to calculate
  # 1. How many words from the first array have a match in the second array
  # 2. The same for the second array, matching words in the first array
  # 3. We need to take into account repeating words (2 repeating words in 
  #    the first array do not match 1 word in the second, only 1 word does).

  my ($words1_idx, $words2_idx);
  
  $words1_idx->{$_} += 1 foreach @words1;
  $words2_idx->{$_} += 1 foreach @words2;  

  my $matched;
  
  foreach my $word (@words1) {
    next if not $words2_idx->{$word};
    $matched += 1;
    $words2_idx->{$word} -= 1;
  }
  
  foreach my $word (@words2) {
    next if not $words1_idx->{$word};
    $matched += 1;
    $words1_idx->{$word} -= 1;
  }
  
  my $total_words = @words1 + @words2;  
  my $match_percent = sprintf("%.2f", $matched / ($total_words / 100));
   
  return $match_percent;
}

# end of FWork::System::Utils::match_strings
1;
