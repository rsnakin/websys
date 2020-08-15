use strict;
use vars qw($defs);

$defs->{if} = {
  pattern => qr/\s*(?:(not)\s+)?([^!=\s\%]+)(?:\s*([!<>=]+|has)\s*(?:"([^"]+)"|([^="\s\%]+)))?(?:\s+(or|and))?\s*/o,
  handler => \&if,
  version => 1.0,
};

my $actions = {
  '='  => 'eq',
  '==' => 'eq',
  '!=' => 'ne',
  '>'  => '>',
  '<'  => '<',
  '<=' => '<=',
  '>=' => '>='
};

sub if {
  my ($self, $content) = @_;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my $t = $self->{template};

  my $compiled;
  
  while (@{$self->{params}}) {
    my ($not, $var, $action, $eq1, $eq2, $sep) = splice @{$self->{params}}, 0, 6;
    my $eq = true($eq1) ? $eq1 : $eq2;

    next if false($var);

    $var = $t->compile(template => $var, tag_start => '', tag_end => '', raw => 1);

# <%if $taxes.position and $taxes.position != 0%> style="display: none;"<%/if%>

    if (defined $eq) {
      # removing single quotes '' if they were used (regexp above doesn't catch'em)
      if ($eq =~ /^'/ and $eq =~ /'$/) {
        $eq =~ s/^'//;
        $eq =~ s/'$//;
      }
      if ($eq =~ /^\$/) {
        $eq = $t->compile(template => $eq, tag_start => '', tag_end => '', raw => 1);
      } else {
        $eq = $t->compile(template => $eq, tag_start => '<', tag_end => '>', raw => 1);
      }
      my $condition;
      # special case of "if $var1 has $var2", $var1 should be an array or a 
      # reference to an array
      if ($action eq 'has') {
        $condition = "(ref($var) and true(grep {\$_ eq $eq} \@{$var})) or (not ref($var) and true($var) and true(grep {\$_ eq $eq} $var))";
      } else {
        $action = $actions->{$action} || 'eq';
        $condition = "$var $action $eq";
      }
      if ($not) {
        $compiled .= "(not ($condition))";
      } else {
        $compiled .= "($condition)";
      }
    } else {
      if ($not) {
        $compiled .= "(false($var))";
      } else {
        $compiled .= "(true($var))";
      }
    }

    $compiled .= " $sep " if $sep;
  }

  $t->add_to_compiled("if($compiled){".$t->compile(template => $content).'}');
}

1;