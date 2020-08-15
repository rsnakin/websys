# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 399 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/encode_html.al)"
sub encode_html {
  my @strings = @_;
  return if not @strings;
  my $html = {
    "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;","'" => "&#39;", "\r" => "",
    "&" => "&amp;"
  };
  foreach (@strings) {
    next if not defined;
    s/(<|>|"|'|\r|&)/$html->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

# end of FWork::System::Utils::encode_html
1;
