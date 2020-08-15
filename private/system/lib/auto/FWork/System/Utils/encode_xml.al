# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 426 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/encode_xml.al)"
sub encode_xml {
  my @strings = @_;
  return if not @strings;
  my $xml = {
    "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;","&" => "&amp;"
  };
  foreach (@strings) {
    next if not defined;
    s/(<|>|"|&)/$xml->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

# end of FWork::System::Utils::encode_xml
1;
