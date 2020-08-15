use strict;
use vars qw($defs);

$defs->{loop} = {
  pattern => qr/^\s*([^=\s\%]+)(?:\s+as\s+([^=\s\%]+))?(?:\s+(steps|one_step)\s*=\s*"?(.+?)"?)?\s*$/o,
  handler => \&loop,
  version => 1.0,
};

sub loop {
  my ($self, $content) = @_;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';
  my ($var, $as, $step_type, $steps) = @{$self->{params}};

  my $t = $self->{template};

  $as = true($as) ? $as : $var;

  my $compiled = '';

  my $as_code = $t->compile(template => $as, tag_start => '', tag_end => '', raw => 1);
  if ($as_code !~ /^\$v/) {
    die 
    "Tag [ $as ] can't be used as a variable in the loop in template [ $t->{tmplname} ]!\n";
  }

  $compiled .= 'my $var='. $t->compile(template => $var, tag_start => '', tag_end => '', raw => 1).';';
  $compiled .= 'if (ref $var eq \'ARRAY\') {';
  # saving original var
  $compiled .= "my \$saved=$as_code;$as_code=undef;";

  $steps = $t->compile(template => $steps, tag_start => '<', tag_end => '>', raw => 1) if true($steps);

  if ($step_type eq 'steps') {
    $compiled .= 'my $loop=[@$var];';

    $compiled .= 'my $st='.$steps.';';
    $compiled .= 'my $counter=0;my $all_counter=0;';
    $compiled .= 'while(@$loop) {';

    # calculating how many records should be in the current step
    $compiled .= 'my $r=@$loop/$st;';
    $compiled .= 'my $steps=($r<=int($r)?int($r):int($r)+1);';

    # decreasing step
    $compiled .= '$st--;';

    # setting special loop variables
    $compiled .= 'if (@$loop == @$var) {'.$as_code.'->{loop_first}=1}';
#    $compiled .= $as_code.'->{loop_odd}=1 if ref '.$as_code.' eq \'HASH\' and ++$counter%2;';
    $compiled .= $as_code.'->{loop_odd}=1 if ref '.$as_code.' and ++$counter%2;';
#    $compiled .= $as_code.'->{loop_idx}=++$all_counter if ref '.$as_code.' eq \'HASH\';';
    $compiled .= $as_code.'->{loop_idx}=++$all_counter if ref '.$as_code.';';

    # creating new loop variable
    $compiled .= $as_code . '->{step}=[splice @$loop,0,$steps];';

    $compiled .= 'if (@$loop == 0) {'.$as_code.'->{loop_last}=1}';

    $compiled .= $t->compile(template => $content);

    $compiled .= 'delete '.$as_code.'->{loop_first};';
    $compiled .= 'delete '.$as_code.'->{loop_last};';
    $compiled .= 'delete '.$as_code.'->{loop_odd};';
    $compiled .= 'delete '.$as_code.'->{loop_idx};';    
    $compiled .= '}';    

    # restoring original var
    $compiled .= "$as_code=\$saved;";
  }
  elsif ($step_type eq 'one_step') {
    $compiled .= 'my $loop = [@$var];';
    $compiled .= 'my $counter=0;my $all_counter=0;';
    $compiled .= 'while (@$loop) {';
  
    # setting special loop variables
    $compiled .= 'if (@$loop == @$var) {'.$as_code.'->{loop_first}=1}';
#    $compiled .= $as_code.'->{loop_odd}=1 if ref '.$as_code.' eq \'HASH\' and ++$counter%2;';
    $compiled .= $as_code.'->{loop_odd}=1 if ref '.$as_code.' and ++$counter%2;';
#    $compiled .= $as_code.'->{loop_idx}=++$all_counter if ref '.$as_code.' eq \'HASH\';';
    $compiled .= $as_code.'->{loop_idx}=++$all_counter if ref '.$as_code.';';
    
    # creating new loop variable
    $compiled .= $as_code.'->{step}=[splice @$loop,0,'.$steps.'];';

    # adding empty variable hashes so that number of array elements will be 
    # equal to $step_value
    $compiled .= 'for (my $i=@{'.$as_code.'->{step}};$i<'.$steps.';$i++) {';
    $compiled .= 'push @{'.$as_code.'->{step}}, {};';
    $compiled .= '}';    

    $compiled .= $t->compile(template => $content);
    
    $compiled .= 'delete '.$as_code.'->{loop_first};';
    $compiled .= 'delete '.$as_code.'->{loop_last};';
    $compiled .= 'delete '.$as_code.'->{loop_odd};';
    $compiled .= 'delete '.$as_code.'->{loop_idx};';    

    $compiled .= '}';    

    # restoring original var
    $compiled .= "$as_code = \$saved;";
  } 
  else {
    # setting special loop variables
#    $compiled .= 'if (ref $var->[0] eq \'HASH\') {$var->[0]->{loop_first}=1;';
    $compiled .= 'if (ref $var->[0]) {$var->[0]->{loop_first}=1;';
    $compiled .= '$var->[$#$var]->{loop_last}=1;}';

    $compiled .= 'my $counter=0;';
    $compiled .= 'foreach my $element (@$var){';
#    $compiled .= '$element->{loop_odd}=1 if ref $element eq \'HASH\' and ++$counter%2;';
    $compiled .= '$element->{loop_odd}=1 if ref $element and ++$counter%2;';
#    $compiled .= '$element->{loop_idx}=$counter if ref $element eq \'HASH\';';    
    $compiled .= '$element->{loop_idx}=$counter if ref $element;';
    $compiled .= "$as_code=\$element;";
    $compiled .= $t->compile(template => $content);
    $compiled .= '}';

    # deleting special variables
#    $compiled .= 'if (ref $var->[0] eq \'HASH\') {delete $var->[0]->{loop_first};';
    $compiled .= 'if (ref $var->[0]) {delete $var->[0]->{loop_first};';
    $compiled .= 'delete $var->[$#$var]->{loop_last};}';

    # restoring original var
    $compiled .= "$as_code=\$saved;";
  }

  $compiled .= '}';

  $t->add_to_compiled($compiled);
}

1;