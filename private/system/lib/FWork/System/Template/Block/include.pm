use strict;
use vars qw($defs);

use FWork::System;
use FWork::System::Utils qw(&quote);

$defs->{include} = {
  pattern => qr/^\s*([^\s]+)(?:\s+from\s+(\S+?))?(?:\s+cache\s*=\s*"?(.+?)"?)?(?:\s+using\s+(\S+?))?(?:\s+(.+?))?\s*$/o,
  single  => 1,
  handler => \&include,
  version => 1.0,
};

sub include {
  my $self = shift;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $t = $self->{template};
  my $pkg = $self->{params}->[1];
  my $cache = $self->{params}->[2];
  my $skin_id = $self->{params}->[3];
  my $flags_string = $self->{params}->[4];
  
  my $file = $t->compile(template => $self->{params}->[0], tag_start => '<', tag_end => '>', raw => 1);

  my ($string, $all_flags_string);
  
  if ($flags_string) {
    $flags_string =~ s/^\s+//;
    $flags_string =~ s/\s+$//;

    my @all_flags;
    while ($flags_string =~ /set_flag="([^"]+)"/g) {
      my $flag_name = $1;
      push @all_flags, $t->compile(template => $flag_name, tag_start => '<', tag_end => '>', raw => 1);
    }
    
    if (@all_flags) {
      $all_flags_string = '['.join(',', @all_flags).']';
    }
  }

  if (true($pkg) and $pkg ne $t->{pkg}->_name) {
    $skin_id = (true($skin_id) ? quote($skin_id) : '$s->{skin}->id');
    $string = "push \@p,\$system->pkg('$pkg')->_template($file, skin_id=>$skin_id,language_id=>\$s->{language}->id";
    $string .= ",cache=>".quote($cache) if $cache;
    $string .= ",flags=>".$all_flags_string if $all_flags_string;
    $string .= ")->parse(\$v);";
  } else {
    $string = "push \@p,\$s->{pkg}->_template($file";
    $string .= ",cache=>".quote($cache) if $cache;
    $string .= ",flags=>".$all_flags_string if $all_flags_string;    
    if (true($skin_id)) {
      $string .= ",skin_id=>".quote($skin_id);
      $string .= ",pkg=>\$s->{pkg}";
    }
    $string .= ")->parse(\$v);";
  }
  $t->add_to_compiled($string);
}

1;