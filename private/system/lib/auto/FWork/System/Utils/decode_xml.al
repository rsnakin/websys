# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 413 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/decode_xml.al)"
sub decode_xml {
  my @strings = @_;
  return if not @strings;
  my $xml = {
    "&lt;" => "<", "&gt;" => ">", "&quot;" => "\"", "&amp;" => "&"
  };
  foreach (@strings) {
    next if not defined;
    s/(&lt;|&gt;|&quot;|&amp;)/$xml->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

# end of FWork::System::Utils::decode_xml
1;
