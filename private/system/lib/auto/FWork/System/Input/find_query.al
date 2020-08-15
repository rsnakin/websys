# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 249 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/find_query.al)"
sub find_query {
  my ($self, $key) = @_;
  return '' if false $key;

  my @found = ();
  foreach my $query (keys %{$self->{query}}) {
    next if $query !~ /$key/;
    push @found, $query;
  }
  return @found;
}

# end of FWork::System::Input::find_query
1;
