# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 233 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/get_query_as_url.al)"
sub get_query_as_url {
  my $self = shift;
  return '' if not $self->{query};
  
  require FWork::System::Utils;
  
  my @query;
  foreach my $key (keys %{$self->{query}}) {
    foreach my $value (@{$self->{query}->{$key}}) {
      push @query, FWork::System::Utils::encode_url($key).'='.FWork::System::Utils::encode_url($value);
    }
  }
  
  return join('&', @query);
}

# end of FWork::System::Input::get_query_as_url
1;
