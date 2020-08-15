# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 124 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/prepare_html_diff.al)"
sub prepare_html_diff {
  my $string_old = shift;
  my $string_new = shift;

  my $seq1 = [split('', $string_old)];
  my $seq2 = [split('', $string_new)];
  
  require Algorithm::Diff;  

  my @diff = Algorithm::Diff::sdiff($seq1, $seq2);
  my $html;
  foreach my $hunk (@diff) {
    # removed
    if ($hunk->[0] eq '-') {
      $html .= '<span style="background-color: #bbb">'.$hunk->[1].'</span>';
    } elsif ($hunk->[0] eq 'u') {
      $html .= $hunk->[1];
    } elsif ($hunk->[0] eq '+') {
      $html .= '<span style="background-color: #cf9">'.$hunk->[2].'</span>';
    } elsif ($hunk->[0] eq 'c') {
      $html .= '<span style="background-color: #ff6">'.$hunk->[2].'</span>';
    }
  }

  return $html;
}

# end of FWork::System::Utils::prepare_html_diff
1;
