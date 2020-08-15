use strict;

# == [ template ] ============================================================

package FWork::System::Template;

use FWork::System;

my $condition = qr/([\/|\$])?(\S+)(?:\s+(.+))?/o;

sub compile {
  my $self = shift;
  # all parameters below are optional, if they are not specified the
  # corresponding values are taken from the template object:
  # template  - template as text that should be parsed
  # tag_start - tag_start
  # tag_end   - tag_end
  my $in = {
    raw => undef, # asks to return raw code from block handlers that care
    @_
  };

  # we return without compiling if plain text was loaded (property exists)
  return '' if exists $self->{plain};

  my $template = exists $in->{template} ? $in->{template} : $self->{template};
  my $tag_start =  exists $in->{tag_start} ? $in->{tag_start} : $self->{tag_start};
  my $tag_end =  exists $in->{tag_end} ? $in->{tag_end} : $self->{tag_end};
  my ($opened, $raw) = (undef, $in->{raw});

  # preparing compiled containers for a new compilation
  unshift @{$self->{compiled_stack}}, '';
  unshift @{$self->{compiled_array}}, [];
  unshift @{$self->{cache}}, {};
 
  # either greedy or non-greedy condition
  my $regexp = true($tag_start) ? qr/.+?/ : qr/.+/;

CYCLE: while ($template =~ /$tag_start\s*($regexp)\s*$tag_end/sg) {
    my ($before, $string, $after, $current) = ($`, $1, $', undef);
    my ($symbol, $type, $exp) = $string =~ /$condition/;

    # found variable
    if ($symbol and $symbol eq '$') {
      # if at least one block is opened -- re-iterate
      next CYCLE if $opened;
      my $exp = '$'.$type.(defined $exp ? ' '.$exp : '');
      $self->block(type => 'plain', raw => $raw)->handle($before) if true($before);
      $self->block(type => 'var', exp => $exp, raw => $raw)->handle;
      $template = $after;
    } 
    
    # found the end of the block
    elsif ($symbol and $symbol eq '/') {
      # if some block is opened and its type is not equal to the current 
      # block type -- re-iterate
      next CYCLE if $opened and $opened->{type} ne $type;
      $opened->{count}--;
      # handle the block
      if ($opened->{count} == 0) {
        $opened->{block}->handle($before);
        $opened = undef;
        # removed one new line if the block end tag is the only one on line
        if ((false($before) or $before =~ /\015\012?|\015?\012$/) and $after =~ /^\015\012?|\015?\012/) {
          $after =~ s/^\015?\012?//;
        }
        $template = $after;
      }
    } 
    
    # found the beginning of the block    
    elsif (not defined $symbol and true($type)) {
      # if some block is opened and its type is not equal to the current 
      # block type -- re-iterate
      next CYCLE if $opened and $opened->{type} ne $type;

      # initiate a new block
      if (not $opened) {
        $self->block(type => 'plain', raw => $raw)->handle($before) if true($before);
        $opened->{block} = $self->block(type => $type, exp => $exp, raw => $raw);
        # remove one new line if the block start tag is the only one on line
        if ((false($before) or $before =~ /\015\012?|\015?\012$/) and $after =~ /^\015\012?|\015?\012/) {
          $after =~ s/^\015?\012?//;
        }
        $template = $after;
      }
      # handle the block if it is single
      if ($opened->{block}->single) {
        $opened->{block}->handle;
        $opened = undef;
        $template = $after;
        next CYCLE;
      }
      $opened->{type} = $type;
      $opened->{count}++;
    }   
  }

  $self->block(type => 'plain', raw => $raw)->handle($template) if true($template);
  $self->{compiled_stack}->[0] = join('.', @{$self->{compiled_array}->[0]}) if $raw and @{$self->{compiled_array}->[0]};

  # removing current compiled containers from the stack
  shift @{$self->{cache}};
  shift @{$self->{compiled_array}};
  return shift @{$self->{compiled_stack}};
}

sub add_to_compiled { $_[0]->{compiled_stack}->[0] .= true($_[1]) ? $_[1] : '' }
sub add_to_raw { push @{$_[0]->{compiled_array}->[0]}, true($_[1]) ? $_[1] : '' }
sub add_to_top { $_[0]->{compiled_top}->{$_[1]} = 1 if true($_[1]) }

sub block    { FWork::System::Template::Block->new(template => @_) }
sub variable { FWork::System::Template::Variable->new(template => @_) }
sub modifier { FWork::System::Template::Modifier->new(template => @_) }

sub replace_in_compiled {
  my ($self, $from, $to) = @_;
  return undef if false($from) or false($to);
  $from = quotemeta($from);
  $self->{compiled_stack}->[0] =~ s/$from/$to/sg;
}

sub write_to_cache {
  my ($self, $content) = @_;
  return if false($content);
  my $var = '$'.FWork::System::Utils::create_random(4, letters_uc => 1, letters_lc => 1);
  while (defined $self->{cache_id}->{$var}) {
    $var = '$'.FWork::System::Utils::create_random(4, letters_uc => 1, letters_lc => 1);
  }
  $self->{cache_id}->{$var} = 1;
  $self->{cache}->[0]->{$content} = $var;
}

sub get_from_cache {
  my ($self, $content) = @_; return undef if false($content);
  $self->{cache}->[0]->{$content};
}

# == [ block ] ===============================================================

package FWork::System::Template::Block;

use vars qw($defs);
use FWork::System;

sub new {
  my ($pkg, $in) = (shift, {
    template => undef, # template object (required)
    type     => undef, # type of block to load (required)
    exp      => undef, # block exp that was found (optional)
    raw      => undef, # a request to return raw code to the caller (optional)
    @_
  });
  return if not $in->{template} or false($in->{type});
  my $self = bless($in, $pkg);
  my $t = $in->{template};

  if (not $defs->{$in->{type}}) {
#    no warnings 'all';
    eval "local \$SIG{__WARN__}; require FWork::System::Template::Block::$in->{type}";
    if (not $defs->{$in->{type}} or not $defs->{$in->{type}}->{handler}) {       
      my $eval_error = $@;
      my $error = qq(Handler for the block "$in->{type}" is unavailable in package ").$t->{pkg}->_name.qq(", skin ").$t->{skin}->id.qq(", template "$t->{tmplname}".);
      $error .= "\n$eval_error" if true($eval_error);
      die $error;
    }
  }
  $self->{$_} = $defs->{$in->{type}}->{$_} foreach (keys %{$defs->{$in->{type}}});
  return $self;
}

sub single { shift->{single} }

sub handle { 
  my $self = shift;
  if (true($self->{pattern}) and true($self->{exp})) {
    @{$self->{params}} = $self->{exp} =~ /$self->{pattern}/g;
  }
  return $self->{handler}->($self, @_);
}

sub optimize {
  my ($self, $line) = @_;
  my $t = $self->{template};
  my $var = $t->get_from_cache("b_$self->{type}_$line");
  if (not $var) {
    $t->write_to_cache("b_$self->{type}_$line");
    return $line;
  } else {
    my $new_line = "($var=$line)";
    if (not $t->get_from_cache("b_$self->{type}_$new_line")) {
      $t->write_to_cache("b_$self->{type}_$new_line");
      $t->replace_in_compiled($line, $new_line);
    }
    return $var;
  }
}

# == [ variable ] ============================================================

package FWork::System::Template::Variable;

use vars qw($defs);
use FWork::System;

sub new {
  my ($pkg, $in) = (shift, {
    template => undef, # template object (required)
    type     => undef, # type of variable to load (required)
    exp      => undef, # variable exp that was found (required)
    @_
  });
  return if not $in->{template} or false($in->{type}) or false($in->{exp});
  my $self = bless $in, $pkg;
  if (not $defs->{$in->{type}}) {
#    no warnings 'all';
    eval "local \$SIG{__WARN__}; require FWork::System::Template::Variable::$in->{type}";
    return if not $defs->{$in->{type}} or not $defs->{$in->{type}}->{handler};
  }
  $self->{$_} = $defs->{$in->{type}}->{$_} foreach (keys %{$defs->{$in->{type}}});
  return $self;
}

sub handle { 
  my $self = shift;
  if (true($self->{pattern}) and true($self->{exp})) {
    @{$self->{params}} = $self->{exp} =~ /$self->{pattern}/g;
  }  
  return $self->{handler}->($self, @_);
}

sub optimize {
  my ($self, $line) = @_;
  my $t = $self->{template};
  my $var = $t->get_from_cache("v_$self->{type}_$line");
  if (not $var) {
    $t->write_to_cache("v_$self->{type}_$line");
    return $line;
  } else {
    my $new_line = "($var=$line)";
    if (not $t->get_from_cache("v_$self->{type}_$new_line")) {
      $t->write_to_cache("v_$self->{type}_$new_line");
      $t->replace_in_compiled($line, $new_line);
    }
    return $var;
  }
}

# == [ modifier ] ============================================================

package FWork::System::Template::Modifier;

use vars qw($defs);
use FWork::System;

sub new {
  my ($pkg, $in) = (shift, {
    template => undef, # template object (required)
    type     => undef, # type of modifier to use (required)
    param    => undef, # modifier parameter (optional)
    @_
  });
  return if not $in->{template} or false($in->{type});
  my $self = bless $in, $pkg;
  my $t = $in->{template};
  if (not defined $defs->{$in->{type}}) {
#    no warnings 'all';
    eval "local \$SIG{__WARN__}; require FWork::System::Template::Modifier::$in->{type}";
    if (not $defs->{$in->{type}} or not $defs->{$in->{type}}->{handler}) {
      my $eval_error = $@;
      my $error = qq(Modifier "$in->{type}" is unavailable in package ").$t->{pkg}->_name.qq(", skin ").$t->{skin}->id.qq(", template "$t->{tmplname}".);
      $error .= "\n$eval_error" if true($eval_error);
      die $error;
    }
  }
  
  $self->{handler} = $defs->{$in->{type}}->{handler};
  return $self;
}

sub handle { 
  my $self = shift;
  return $self->{handler}->($self, @_);
}

sub optimize {
  my ($self, $line) = @_;
  my $t = $self->{template};
  my $var = $t->get_from_cache("m_$self->{type}_$line");
  if (not $var) {
    $t->write_to_cache("m_$self->{type}_$line");
    return $line;
  } else {
    my $new_line = "($var=$line)";
    if (not $t->get_from_cache("m_$self->{type}_$new_line")) {
      $t->write_to_cache("m_$self->{type}_$new_line");
      $t->replace_in_compiled($line, $new_line);
    }
    return $var;
  }
}

1;