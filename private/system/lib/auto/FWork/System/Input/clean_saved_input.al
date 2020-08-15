# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 567 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/clean_saved_input.al)"
sub clean_saved_input {
  my $self = shift;
  my $in = {
    dir => undef, # physical path to the directory where the input is stored on disk
    @_
  };
  my $dir = $in->{dir};
  return undef if false($dir);
 
  my $temp_path = $system->path.'/private/system/temp';
  return undef if not -d $temp_path;

  # remove directories that are older then this number of minutes
  my $old_dir_mins = 10;

  my $current_time = time();
  return undef if not opendir(DIR, $temp_path);

  require File::Path;

  while (my $dir = readdir(DIR)) {
    next if not -d $dir;
    next if $dir !~ /^sid\./;

    # modified time
    my $modified_time = (stat($temp_path.'/'.$dir))[9];
    next if ($current_time - $modified_time) < ($old_dir_mins*60);

    File::Path::rmtree($temp_path.'/'.$dir);
  }

  closedir(DIR);
}

1;
# end of FWork::System::Input::clean_saved_input
