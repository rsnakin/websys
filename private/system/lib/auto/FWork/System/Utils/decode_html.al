# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 385 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/decode_html.al)"
sub decode_html {
  my @strings = @_;
  return if not @strings;
  my $html = {
    "&lt;" => "<", "&gt;" => ">", "&quot;" => "\"", "&#39;" => "'", 
    "&amp;" => "&"
  };
  foreach (@strings) {
    next if not defined;
    s/(&lt;|&gt;|&quot;|&#39;|&amp;)/$html->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

# end of FWork::System::Utils::decode_html
1;
