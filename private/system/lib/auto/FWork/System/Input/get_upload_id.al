# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 195 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/get_upload_id.al)"
sub get_upload_id {
  my $self = shift;
  $self->check_temp_path;
  my $uploads_dir = (true($self->{temp_path}) ? $self->{temp_path}.'/' : '').'__form_uploads';
  
  if (not -d $uploads_dir) {
    mkdir $uploads_dir, 0777 || die "Directory for form uploads [ $uploads_dir ] doesn't exist and we can't create it: $!";    
  }

  # removing upload directories which are more then 24 hours old
  my $threshold_sec = time()-24*60*60;

  opendir(DIR, $uploads_dir) || die "Can't open form uploads directory [ $uploads_dir ] for reading: $!";
  my @old_dirs = map {"$uploads_dir/$_"} grep {
    $_ !~ /^\.+$/ and -d "$uploads_dir/$_" and (stat("$uploads_dir/$_"))[9] < $threshold_sec  
  } readdir(DIR);
  closedir(DIR);
  
  if (@old_dirs and eval {require File::Path}) {
    foreach my $dir (@old_dirs) {
      File::Path::rmtree($dir);
    }
  }
  
  require FWork::System::Utils;
  
  my $dir_exists = 1;
  my $upload_id = undef;
  while ($dir_exists) {
    $upload_id = FWork::System::Utils::create_random(10);
    if (mkdir($uploads_dir.'/'.$upload_id), 0777) {
      $dir_exists = undef;
    } 
  }
  
  return $upload_id;
}

# end of FWork::System::Input::get_upload_id
1;
