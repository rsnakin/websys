# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 483 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/restore_input_from_disk.al)"
sub restore_input_from_disk {
  my $self = shift;
  my $in = {
    dir => undef, # physical path to the directory where the input is currently stored
    @_
  };
  my $dir = $in->{dir};
  return undef if false($dir);

  require FWork::System::File;
  require Storable;

  my $input_file = $dir.'/input.storable';
  my $save = FWork::System::File->new($input_file, 'r') || die "Can't open file $input_file for reading: $!";
  my $input = Storable::thaw($save->contents);
  $save->close;
  
  unlink($input_file);
  
  $self->{$_} = FWork::System::Utils::clone($input->{$_}) for keys %$input;
  
  if ($self->{files}) {
    $self->check_temp_path;
    
    foreach my $name (keys %{$self->{files}}) {
      my $file = $self->{files}->{$name};
      next if not -f $dir."/$file->{__tmp_filename}";
  
      my $tmp_filename = create_random().'.form';
      my $tmpfile = $self->{__upload_path}.$tmp_filename;
      
      FWork::System::Utils::cp($dir."/$file->{__tmp_filename}", $tmpfile);
      unlink($dir."/$file->{__tmp_filename}");

      $file->{file} = FWork::System::File->new($tmpfile, "r", {is_temp => 1}) || die "Can't open file $tmpfile for reading: $!";
      $file->{file}->close;
      
      $file->{__full_tmp_path} = $tmpfile;
      $file->{__tmp_filename} = $tmp_filename;
      
      $self->{query}->{$name} = [$self->{files}->{$name}];
    }
  }
  
  # all files in the directory should be deleted now, so we try to delete the
  # directory, if there are any files left in it, the directory will not be 
  # removed automatically. 
  rmdir($dir);

  return 1;
}

# end of FWork::System::Input::restore_input_from_disk
1;
