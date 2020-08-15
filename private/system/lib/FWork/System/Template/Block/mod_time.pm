use strict;

use FWork::System;
use vars qw($defs);

$defs->{mod_time} = {
  pattern => qr/^\s*$/o,
  handler => \&mod_time,
  version => 1.0,
};

sub mod_time {
  my ($self, $content) = @_;
  my $t = $self->{template};
  
  my $final = $t->compile(template => $content, raw => 1);

  $t->add_to_top("require FWork::System::Utils; FWork::System::Utils->import('&pub_file_mod_time');");
  $final = 'pub_file_mod_time('.$final.')';

  $self->{raw} ? $t->add_to_raw($final) : $t->add_to_compiled("push \@p,$final;");
}

1;