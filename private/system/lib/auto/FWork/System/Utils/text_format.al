# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 662 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/text_format.al)"
sub text_format {
  my $txt = shift;
  my $length = shift;
  
  $txt =~ s/\r//g;
  my @lines = split(/\n/, $txt);
  my @formatted;
  
  while (@lines) {
    my $line = shift @lines;
    if (length($line) > $length and (my $index = index($line, ' ', $length)) > -1) {
      push @formatted, substr($line, 0, $index);
      unshift @lines, substr($line, $index+1)
    } elsif ($line ne '' and @lines and $lines[0] ne '') {
      $lines[0] = $line.' '.$lines[0];
    } else {  
      push @formatted, $line;
    }
  }
  
  return join("\n", @formatted);
}

# end of FWork::System::Utils::text_format
1;
