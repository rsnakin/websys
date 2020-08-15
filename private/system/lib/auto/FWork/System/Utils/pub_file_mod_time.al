# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 69 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/pub_file_mod_time.al)"
sub pub_file_mod_time {
  my $url = shift;
  return undef if false($url);
  
  my $pub_path = $system->config->get('public_path'); 
  my $pub_url = quotemeta($system->config->get('public_url'));
  (my $site_root = $pub_path) =~ s/$pub_url$//;
  
  my $file_path = $site_root.$url;
  return $url if not -f $file_path;
  
  $url .= ($file_path =~ /\?/ ? '&' : '?').'__m='.(stat($file_path))[9];
  
  return $url;
}

# end of FWork::System::Utils::pub_file_mod_time
1;
