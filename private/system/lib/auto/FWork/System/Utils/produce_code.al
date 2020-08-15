# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 548 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/produce_code.al)"
sub produce_code {
  my ($data, $options) = (shift, {@_});
  
  my $space = $options->{spaces} ? ' ' : '';
  my $arrow = $options->{json} ? ':' : '=>';

  return ($options->{json} ? 'null' : 'undef') if not defined $data;
  return quote($data) if false($data) or not ref $data;

  if ($options->{allow_blessed}) {
    delete $options->{allow_blessed} if not eval "require Scalar::Util";
  }
  
  my $result;
  my $ref_type = ($options->{allow_blessed} ? Scalar::Util::reftype($data) : ref $data);
  
  if ($ref_type eq 'HASH') {
    my @items = ();
    foreach (keys %$data) {
      push @items, quote($_).$space.$arrow.$space.produce_code($data->{$_}, %$options);
    }
    $result = '{'.join(",$space", @items).'}';
  } elsif ($ref_type eq 'ARRAY') {
    my @items = ();
    foreach (@$data) {
      push @items, produce_code($_, %$options);
    }
    $result = '['.join(",$space", @items).']';
  }
  
  return $result;
}

# end of FWork::System::Utils::produce_code
1;
