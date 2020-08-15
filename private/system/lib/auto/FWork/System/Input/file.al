# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 261 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/file.al)"
sub file {
  my ($self, $file) = @_;
  return keys %{$self->{files}} if not defined $file;
  return $self->{files}->{$file};
}

# end of FWork::System::Input::file
1;
