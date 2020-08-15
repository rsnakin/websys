# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 151 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/format_thousands.al)"
sub format_thousands {
  my $num = shift;
  return $num if not $num or length($num) <= 3;

  my ($fraction) = $num =~ /(\.\d+)$/;
  if (true($fraction)) {
    $num =~ s/\.\d+$//g
  } else {
    $fraction = '';
  }

  my $temp_line_str;
  my @chars = split('', $num);
  while (@chars > 3) {
    my $order3 = pop(@chars);
    $order3 = pop(@chars).$order3;
    $order3 = pop(@chars).$order3;            
    
    $temp_line_str = ','.$order3.$temp_line_str
  }

  return join('', @chars).$temp_line_str.$fraction;  
}

# end of FWork::System::Utils::format_thousands
1;
