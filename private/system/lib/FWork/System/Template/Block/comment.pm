use strict;
use vars qw($defs);

$defs->{comment} = {
  pattern => qr/^\s*$/o,
  handler => \&comment,
  version => 1.0,
};

sub comment {}

1;