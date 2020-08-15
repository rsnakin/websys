# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 525 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/parse_urls.al)"
sub parse_urls {
  my ($string) = @_;
  return if false($string);

  $string =~ s/((?:https?|ftp):\/\/[\w\.\-]+)/<a href="$1">$1<\/a>/sg;
  $string =~ s/([^\/])(www\.[\w\.\-]+)/$1<a href="http:\/\/$2">$2<\/a>/sg;
  $string =~ s/([\.\w\-]+@[\.\w\-]+\.[\.\w\-]+)/<a href="mailto:$1">$1<\/a>/sg;

  return $string;
}

# end of FWork::System::Utils::parse_urls
1;
