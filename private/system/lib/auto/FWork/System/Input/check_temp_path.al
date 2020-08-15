# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 168 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/check_temp_path.al)"
sub check_temp_path {
  my $self = shift;
  
  if (true($self->{temp_path}) and not -d $self->{temp_path}) {
    mkdir $self->{temp_path}, 0777 || die "Directory for storing temporary files [ $self->{temp_path} ] doesn't exist and we can't create it: $!";
  }
  
  return 1;
}

# end of FWork::System::Input::check_temp_path
1;
