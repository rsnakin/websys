use strict;
use vars qw($defs);

$defs->{plain} = {
  handler => \&plain,
  version => 1.0,
};

sub plain {
  my ($self, $content) = @_;
  return if not defined $content;
  my $t = $self->{template};
  if ($self->{raw}) {
    $t->add_to_raw(FWork::System::Utils::quote($content));
  } else {
    $t->add_to_compiled('push @p,'.FWork::System::Utils::quote($content).';');
  }
}

1;