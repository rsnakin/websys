# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 714 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/cut_string.al)"
sub cut_string {
  my $string = shift;
  my $length = shift;
  return '' if false($string) or not $length;
  return $string if length($string) <= $length;
  
  my $sub_string = substr($string, 0, $length);
  my $next_chr = substr($string, $length-1, 1);

  # ends with a space already
  if ($sub_string =~ /\s+$/) {
    $sub_string =~ s/\s+$//s;
  } 

  # next character in line was space or full stop
  elsif ($next_chr eq ' ' or $next_chr eq '.') {
    $sub_string =~ s/\s+$//s;
  }
  
  # we are probably in the middle of the word
  else {
    $sub_string =~ s/\s+\S+$//s;
  }
  
	$sub_string .= '...'; 
  
  return $sub_string;
}

# end of FWork::System::Utils::cut_string
1;
