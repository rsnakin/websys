# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 535 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/save_input_to_disk.al)"
sub save_input_to_disk {
  my $self = shift;
  my $in = {
    dir => undef, # physical path to the directory where the input will be saved
    @_
  };
  my $dir = $in->{dir};
  return undef if false($dir);
  
  require FWork::System::File;
  require Storable;
  
  FWork::System::Utils::create_dirs($dir) if not -d $dir;

  my $input = {map { $_ => FWork::System::Utils::clone($self->{$_}) } qw(__stdin __upload_path query files)};
  if ($input->{files}) {
    foreach my $name (keys %{$input->{files}}) {
      my $file = $input->{files}->{$name};
      FWork::System::Utils::cp($file->{__full_tmp_path}, $dir."/$file->{__tmp_filename}");
      delete $input->{query}->{$name};
      delete $file->{file};
    }
  }

  
  my $input_file = $dir.'/input.storable'; 
  my $save = FWork::System::File->new($input_file, 'w') || die "Can't open file $input_file for writing: $!";
  $save->print(Storable::nfreeze($input))->close;
  
  return 1;
}

# end of FWork::System::Input::save_input_to_disk
1;
