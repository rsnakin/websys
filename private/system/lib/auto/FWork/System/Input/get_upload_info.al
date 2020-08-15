# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 178 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/get_upload_info.al)"
sub get_upload_info {
  my $self = shift;
  my $in = {
    upload_id => undef,
    @_
  };
  my $upload_id = $in->{upload_id};
  return undef if false($upload_id);

  my $config_file = (true($self->{temp_path}) ? $self->{temp_path}.'/' : '').'__form_uploads/'.$upload_id.'/info.cgi';
  
  require FWork::System::Config;
  my $config = FWork::System::Config->new($config_file); 
  
  return $config->get_all;
}

# end of FWork::System::Input::get_upload_info
1;
