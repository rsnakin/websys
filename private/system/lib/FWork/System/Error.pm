package FWork::System::Error;

$VERSION = 1.00;

use strict;

use FWork::System;

sub new { 
  my $class = shift;
  my $self = bless({}, $class);                                              
  return $self;
}

# ============================================================================
# Group: Methods for working with web error instance

# Method: setup
#
# Creates and returns new web error instance
#
# Parameters:
#
# pkg - <FWork::System::Package> object which error should call if thrown;
# it is optional if you just want to <FWork::System::Error::Web::announce> an 
# error
# action - name of the action which error should call if thrown; it is optional
# if you just want to <FWork::System::Error::Web::announce> an error
# form -  name of the form in the template, where the fields should be marked as 
# containing errors, optional
#
# Returns:
#
# <FWork::System::Error::Web> object

sub setup {
  my $self = shift;
  my $in = {
    pkg    => undef, # optional if you don't want to throw an error
    action => undef, # optional if you don't want to throw an error
    form   => undef,
    @_
  };

  require FWork::System::Error::Web;
  return FWork::System::Error::Web->new(container => $self, %$in);
}

# Method: was_thrown
#
# Checks wether at least one error was already thrown or announced (note: 
# setting up an error and throwing it or announcing it are different things). 
#
# Returns:
#
# 1 - if error was thrown
# undef - if no error was thrown

sub was_thrown {
  my $self = shift;
  return ($self->{_stack} and @{$self->{_stack}} ? 1 : undef);
}

# Method: clear
#
# Removes any logged errors from the state, after that was_thrown will return
# undef as if no errors were thrown
#
# Returns:
#
# 1 - always

sub clear {
  my $self = shift;
  delete $self->{_stack};
  return 1;
}

# Method: get_error
#
# Returns the specified <FWork::System::Error::Web> object from the stack. 
# Stack is used to save errors at the moment when they are thrown. So if no
# errors were thrown yet, this method will return undef.
#
# Parameters:
#
# 1st - specifies what error to return, could be "first", "last" or number of 
#       the error in the stack (starting from 0)
#
# Returns:
#
# <FWork::System::Error::Web> object

sub get_error {
  my $self = shift;
  my $what = shift;

  # return undef if stack is not present or is empty
  return undef if not $self->{_stack} or not @{$self->{_stack}};

  # return the whole stack of errors if it was not specified what to return,
  # or the stack is empty (doesn't exist)
  return $self->{_stack} if false($what);

  if (lc($what) eq 'first') {
    return $self->{_stack}->[0];
  } elsif (lc($what) eq 'last') {
    return $self->{_stack}->[$#{$self->{_stack}}];
  } elsif ($what =~ /^\d+$/) {
    return $self->{_stack}->[$what];    
  }

  return undef;
}

sub delete_warning_from_db {
  my $self = shift;
  my $in = {
    warn_id => undef,
    @_
  };
  my $warn_id = $in->{warn_id};
  return undef if not $warn_id;

  my $pre = $system->config->get('db_prefix');
  
  $warn_id = $system->dbh->quote($warn_id);
  
  $system->dbh->do("
delete from ${pre}system_warnings where warn_id = $warn_id
  ");
  
  $system->dbh->do("
delete from ${pre}system_warnings_tags where warn_id = $warn_id
  ");  
  
  return 1;
}

sub get_warning_from_db {
  my $self = shift;
  my $warn_id = shift;
  return undef if not $warn_id;
  
  my $pre = $system->config->get('db_prefix');
  
  my $sth = $system->dbh->prepare("
select * from ${pre}system_warnings where warn_id = ?
  ");
  $sth->execute($warn_id);
  my $warning = $sth->fetchrow_hashref;
  $sth->finish;
  
  if ($warning) {
    $sth = $system->dbh->prepare("
select * from ${pre}system_warnings_tags where warn_id = ?    
    ");
    $sth->execute($warn_id);
    while (my $row = $sth->fetchrow_hashref) {
      push @{$warning->{tags}}, $row->{tag};
    }
  }
  
  return $warning;
}

sub get_all_warnings_tags_from_db {
  my $self = shift;
  my $in = {
    critical  => undef, # optional
    @_
  };
  my $critical = $in->{critical};
  
  my ($where_arr, $tags);

  if (true($critical) && $critical =~ /^(?:0|1)$/ ) {
    push @$where_arr, "w.critical = $critical";
  }
  
  my $where = ($where_arr ? 'where '.join(' and ', @$where_arr) : '');
  
  my $pre = $system->config->get('db_prefix');
  
  my $sth = $system->dbh->prepare("
select distinct(tag) as name
from ${pre}system_warnings_tags wt
inner join ${pre}system_warnings w on w.warn_id = wt.warn_id
$where
order by name   
  ");
  $sth->execute;
  while (my $row = $sth->fetchrow_hashref) {
    push @$tags, $row;
  }
  $sth->finish;
  
  return $tags;
}

sub get_all_warnings_from_db {
  my $self = shift;
  my $in = {
    critical  => undef, # optional
    from      => undef, # optional
    total     => undef, # optional
    tags      => undef, # optional, ARRAY ref of tags
    vis_ip    => undef, # optional, search by visitor IP
    get_tags  => undef, # optional, will get all tags for each warning
    @_
  };
  my $critical = $in->{critical};
  my $from = $in->{from};
  my $total = $in->{total};
  my $tags = $in->{tags};
  my $vis_ip = $in->{vis_ip};
  my $get_tags = $in->{get_tags};
  
  my $pre = $system->config->get('db_prefix');
  
  my ($warnings, $where_arr);
  my $tags_join = '';
  
  if (true($critical) && $critical =~ /^(?:0|1)$/ ) {
    push @$where_arr, "w.critical = $critical";
  }
  
  if (true($vis_ip)) {
    push @$where_arr, 'w.vis_ip = '.$system->dbh->quote($vis_ip);
  }
  
  if ($tags and ref $tags eq 'ARRAY' and @$tags) {
    my $join_arr;
    for (my $i = 0; $i < scalar @$tags; $i++) {
      push @$join_arr, "inner join ${pre}system_warnings_tags as wt$i on wt$i.warn_id = w.warn_id and wt$i.tag = ".$system->dbh->quote($tags->[$i])
    } 
    $tags_join = join("\n", @$join_arr);
  }

  my $where = ($where_arr ? 'where '.join(' and ', @$where_arr) : '');
  
  my $limit = '';
  if (true($from) and true($total)) {
    $limit = "limit $from, $total";  
  }
  
  my @ids;
  
  # do not select extended by default
  my $sth = $system->dbh->prepare("
select 
  w.warn_id, w.warn_date, w.system_id, w.vis_ip, w.warn_message, w.critical,
  if(isnull(warn_extended), null, 1) as has_warn_extended 
from ${pre}system_warnings as w
$tags_join
$where
group by w.warn_id
order by w.warn_date desc, w.warn_id desc
$limit
  ");
  $sth->execute;
  while (my $row = $sth->fetchrow_hashref) {
    push @ids, $row->{warn_id};
    push @$warnings, $row;
  }
  
  if (wantarray) {
    $sth = $system->dbh->prepare("
select count(distinct w.warn_id) 
from ${pre}system_warnings as w
$tags_join 
$where
    ");
    $sth->execute;
    $total = $sth->fetchrow_array;
  }
  
  if ($get_tags and $warnings) {
    my $tags_idx;
    my $sql_in = join(',', @ids);
    $sth = $system->dbh->prepare("
select *
from ${pre}system_warnings_tags
where warn_id in ($sql_in)
    ");
    $sth->execute;
    while (my $row = $sth->fetchrow_hashref) {
      push @{$tags_idx->{$row->{warn_id}}}, $row->{tag};
    }
    foreach my $warn (@$warnings) {
      next if not $tags_idx->{$warn->{warn_id}};
      $warn->{tags} = $tags_idx->{$warn->{warn_id}};
    }
  }
  
  $sth->finish;
  
  return wantarray ? ($warnings, $total) : $warnings;
}

# get average warnigns per hour for the past 24 hours
sub get_warning_averages {
  my $self = shift;
  my $in = {
    critical  => undef, # optional
    tags      => undef, # optional, ARRAY ref of tag names
    hours     => undef, # optional
    @_
  };
  my $critical = $in->{critical};
  my $tags = $in->{tags};
  
  my $pre = $system->config->get('db_prefix');
  
  my $hours = $in->{hours} || 24;
  
  my $where_arr = ['w.warn_date >= now() - interval '.$hours.' hour'];
  my $tags_join = '';
  
  if (true($critical) && $critical =~ /^(?:0|1)$/ ) {
    push @$where_arr, "w.critical = $critical";
  }

  if ($tags and ref $tags eq 'ARRAY' and @$tags) {
    my $join_arr;
    for (my $i = 0; $i < scalar @$tags; $i++) {
      push @$join_arr, "inner join ${pre}system_warnings_tags as wt$i on wt$i.warn_id = w.warn_id and wt$i.tag = ".$system->dbh->quote($tags->[$i])
    } 
    $tags_join = join("\n", @$join_arr);
  }

  my $where = 'where '.join(' and ', @$where_arr);
  my ($warnings_idx, $warnings);

  # do not select extended by default
  my $sth = $system->dbh->prepare("
select 
  date_format(w.warn_date, '%Y-%m-%d-%H') as avg_hour, 
  count(distinct w.warn_id) as total_warnings
from ${pre}system_warnings as w
$tags_join
$where
group by avg_hour
limit 25
  ");
  $sth->execute;
  while (my $row = $sth->fetchrow_hashref) {
    $warnings_idx->{$row->{avg_hour}} = $row;
  }
  
  if ($warnings_idx) {
    my @sql;
    for my $hour (0..24) {
      push @sql, "date_format(now()-interval $hour hour, '%Y-%m-%d-%H') as hour$hour";
    }
    
    $sth = $system->dbh->prepare('select '.join(',', @sql));
    $sth->execute;
    my $hours = $sth->fetchrow_hashref;
    
    $sth->finish;
    
    for my $hour (0..24) {
      next if $warnings_idx->{$hours->{'hour'.$hour}};
      $warnings_idx->{$hours->{'hour'.$hour}} = {
        avg_hour        => $hours->{'hour'.$hour},
        total_warnings  => 0,
      };
    }
    
    $warnings = [map {$warnings_idx->{$_}} sort {$a cmp $b} keys %$warnings_idx];
  }

  return $warnings;
}

sub clean_warnings_from_db {
  my $self = shift;
  my $in = {
    keep_hours  => undef, # how many hours to keep
    critical    => undef, # optional, requests to delete critical warnings too 
    @_
  };
  my $keep_hours = $in->{keep_hours};
  $keep_hours = 24 if false($keep_hours);
  my $critical = $in->{critical};

  my $add_where = ($critical ? '' : 'and critical = 0');
  
  my $pre = $system->config->get('db_prefix');
  
  my $warnings;
  
  # we can't use multi-delete here, because not all warnings have corresponding
  # tags in tags table and nothing is being deleted without them
  my $sth = $system->dbh->prepare("
select warn_id
from ${pre}system_warnings
where warn_date < (now() - interval $keep_hours hour)
$add_where
  ");
  $sth->execute;
  while (my $warn_id = $sth->fetchrow_array) {
    push @$warnings, $warn_id;
  }
  
  if ($warnings) {
    my $sql_in = join(',', @$warnings);

    $system->dbh->do("
delete from ${pre}system_warnings where warn_id in (".$sql_in.")
    ");
    
    $system->dbh->do("
delete from ${pre}system_warnings_tags where warn_id in (".$sql_in.")
    ");    
  }
  
  $system->dbh->do("optimize table ${pre}system_warnings");
  $system->dbh->do("optimize table ${pre}system_warnings_tags");
  
  return 1;
}

# Method: _save_error
#
# Saves error in the stack at the moment when it is thrown. It is used 
# internally by <FWork::System::Error::Web> class.
#
# Parameters:
#
# 1st - specifies <FWork::System::Error::Web> object
#
# Returns:
#
# <FWork::System::Error> object

sub _save_error {
  my $self = shift;
  my $error = shift;
  return undef if not $error;

  push @{$self->{_stack}}, $error;

  return $self;
}

sub _clean_file_for_log {
  my $file = shift;
  my $path = $system->path;
  $file =~ s/\s+\(autosplit[^\)]+\)//;
  $file =~ s/$path//;
  $file =~ s/\.\//\//;
  # windows paths
  $file =~ s/\\/\//g;
  return $file;
}

# ============================================================================
# Group: General error methods

# Method: die
#
# Generally works the same as the core "die" function, if it was invoked
# from inside the FWork System. When invoked it prints out headers,
# using <FWork::System::Output::_print_header> and then calls <_just_die>.
#
# Parameters:
#
# 1st - specifies the die message

sub die {
  my $self = shift;
  my $message = shift;
  return undef if false($message);

  if ($message !~ /\n$/) {
    my ($package, $filename, $line) = caller;
    $filename = _clean_file_for_log($filename);
    $message .= " at $filename line $line\n";
  }

  $system->out->_print_header;
  _just_die($message);
}

# Method: warn
#
# Is used to log a message to the FWork System error log, if logging is
# turned on. 
#
# Parameters:
#
# 1st - specifies the warning message
#
# Returns:
#
# Nothing useful

sub warn {
  my $self = shift;
  my $message = shift;
  return undef if false($message);

  my ($package, $filename, $line) = caller;
  $message .= " at $filename line $line\n" if $message !~/\n$/;

  _log_warning($message, @_);
}

# ============================================================================
# Group: Internal functions, not meant to be used outside this package

# Function: _log_warning
#
# Logs a warning to a db table if this option is swtiched on in system config,
# otherwise calles a _log_error.
#
# Parameters:
#
# 1st - specifies the warning message

sub _log_warning {
  my $message = shift;
  my $in = {
    critical  => undef, # optional
    extended  => undef, # optional
    tags      => undef, # optional
    @_
  };
  return undef if false($message);

  my $tags = ($in->{tags} and ref $in->{tags} eq 'ARRAY' and @{$in->{tags}} ? $in->{tags} : undef);
  # leaving only unique tags
  if ($tags) {
    my $tags_idx;
    $tags = [grep {$tags_idx->{$_} == 1} map {$tags_idx->{$_} += 1; $_} @$tags];
  }

  my $config = $system->config;
  return undef if not $config or not $config->get('log_errors');

  if ($config->get('warnings_to_db')) {
    require FWork::System::Utils;
    my $ip = FWork::System::Utils::get_ip();

    my $pre = $system->config->get('db_prefix');

    my $system_id = $system->config->get('system_id');
    
    my $sth = $system->dbh->prepare("
insert into ${pre}system_warnings 
set warn_date = now(), system_id = ?, vis_ip = ?, warn_message = ?, warn_extended = ?, critical = ?
    ");
    $sth->{RaiseError} = 0;
    $sth->execute($system_id, $ip, $message, $in->{extended}, ($in->{critical} ? $in->{critical} : 0));
    my $warn_id = $system->dbh->{mysql_insertid};
    $sth->finish;
    
    if ($warn_id and $tags) {
      $sth = $system->dbh->prepare("
insert into ${pre}system_warnings_tags
set warn_id = ?, tag = ?      
      ");
      foreach my $tag (@$tags) {
        next if false($tag);
        $sth->execute($warn_id, $tag);
      }
      $sth->finish;
    }
    
  } else {
    if ($tags) {
      $message = '[Tags: '.join(', ', @$tags).'] '.$message;
    }
    _log_error($message);
  }
}

# Function: _log_error
#
# Tries to log a specified error to the FWork System error log (if logging
# is switched on). The location of the log file is taken from "errors_file"
# parameters in system config. If it is not specified the default location
# is used: "private/.ht_errors.log".
#
# Parameters:
#
# 1st - specifies the error message

sub _log_error {
  my $message = shift;
  return undef if false($message);

  my $config = $system->config;

  # logging error in the system error log if log_errors option is on in config
  if ($config and $config->get('log_errors')) {
    my $file = $config->get('errors_file');
    # relative path, we add system path in fron
    if (true($file) and $file !~ /^\//) {
      $file = $system->path.'/'.$file
    } 
    # file not specified, using default file name and location
    elsif (false($file)) {
      $file = $system->path.'/private/.ht_errors.log';
    }
  
    if (open(LOG, '>> '.$file)) {
      require FWork::System::Utils;
      my $ip = FWork::System::Utils::get_ip();
      
      flock LOG, 2 | 4;
      chomp(my $log_message = $message);
      print LOG '['.scalar localtime()." - $ip] $log_message\n\n";
      flock LOG, 8;
      close(LOG);
    }
  }
}

# Function: _just_die
#
# A die handler, it is specified as a reference to CGI::Carp when FWork System
# initializes. It relies on CGI::Carp to deliver content-type header to the 
# browser if needed. It will try to log an error to the FWork System error
# log (if logging is switched on), it will also try to display file contents
# to the STDOUT instead of the actual error message if "error_file" parameter
# in system configuration is defined. At the end, it always stops the system
# (with <FWork::System::stop>).
#
# Parameters:
#
# 1st - specifies the die message

sub _just_die {
  my $message = shift;
  my $config = $system->config;

  my $trace;  

  my @stack;
  my $counter = 0;
  while (my @frame = caller($counter)) {
    push @stack, \@frame;
    $counter += 1;
  }    
  
  for (my $i = 0; $i < scalar @stack; $i++) {
    my $frame = $stack[$i];
    my $sub = ($stack[$i+1] ? $stack[$i+1]->[3].'()' : 'main()');
    my $file = _clean_file_for_log($frame->[1]);
    $trace .= "-- $sub, $file line $frame->[2];\n";
  }
  
  my $stack_message = '';
  if (true($trace)) {
    $stack_message .= "\n" if $message !~ /\n$/;
    $stack_message .= "Stack trace:\n".$trace;
  }

  _log_error($message.$stack_message);

  # showing special file contents to the user instead of an error.
  if ($config and $config->get('error_file') and 
      $system->out and $system->out->context eq 'web' and
      open(F, '<'.$config->get('error_file'))) 
  {
    my $contents = join('', <F>);
    close(F);
    print $contents;
    $system->stop;
  } 

  if ($system->out->context eq 'web') {
#     $system->out->redirect('/system/error_page.html');

#     $message =~ s/\n/<br>/sg;
  
#     my $HTML = <<HTML;
# <div style="font-size: 11pt;">
# <strong style="font-size: 16pt;">System error has just occured:</strong>
# 
# <p style="color: #555; padding: 10px; border: 1px dotted black;">$message</p>
# 
# We are sorry for any inconvenience this error might have caused. Be assured that we
# are already working on solving the problem.
# </div>
# HTML
#     
    open(F, '<'.$config->get('error_message_html'));
    my $HTML; while(<F>){ $HTML .= $_; } close(F);
#     $system->out->header(Status => '500 Internal Server Error');
#     $system->out->say($HTML);
    print $HTML;
  } else {
    print $message;
  }

  $system->stop;
}

1;