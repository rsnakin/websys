# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 365 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/dump.al)"
sub dump { 
  my $data = shift;
  my $options = {@_};
  require Data::Dumper;
  my $dump = Data::Dumper::Dumper($data);
  
  if (true($options->{file})) {
    require FWork::System::File;    
    my $f = FWork::System::File->new($options->{file}, 'w');
    return undef if not $f;
    $f->print($dump)->close; 
    return 1;
  }
  
  my $result = '<pre>'.$dump.'</pre>';
  return $result if $options->{return};
  $system->out->say($result);
  exit if not $options->{no_exit};
}

# end of FWork::System::Utils::dump
1;
