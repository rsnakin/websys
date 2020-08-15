use strict;
use vars qw($defs);

$defs->{limit} = {
  pattern => qr/^\s*length="?(\d+)"?\s*$/o,
  handler => \&limit,
  version => 1.0,
};

use FWork::System::Utils qw(&create_random &quote);

sub limit {
  my ($self, $content) = @_;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my $limit = $self->{params}->[0];
  $limit ||= 0;

  my $t = $self->{template};

  my $var_name = '$tmp->{limit_'.create_random(6).'}';

  # symbol that should be used for creating require length
  my $fill = ' ';
  my $fill_quoted = quote($fill);
  
  my $compiled = "$var_name=substr(".$t->compile(template => $content, raw => 1).",0,$limit);";
  $compiled .= "push \@p,$var_name.${fill_quoted}x($limit-length($var_name));";

  $t->add_to_top('my $tmp;');
  $t->add_to_compiled($compiled);
}

1;