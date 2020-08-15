package FWork::System::DBI;

$VERSION = 1.10;

use strict;
use vars qw($AUTOLOAD);
# use utf8;
use FWork::System;

# ============================================================================
# we use package variables for functions, because all normal subs inside the
# package should always correspond to actual DBI and STH methods

# ============================================================================
# object & class methods

sub new {
  my $class = shift;
  my $config = $system->config;
  my $db_type = $config->get('db_type');

  # recursion detected
  return undef if $system->stash('__system_connecting_to_db');

  $system->stash(__system_connecting_to_db => 1);

  if (not eval "require FWork::System::DBI::$db_type") {
    die "Database type '$db_type' is not supported by the DBI class in this installation of FWork System! $@\n";
  }

  my ($dbh, $dbh_read);

  my %conn_params = (
    db_name => $config->get('db_name'),
    db_host => $config->get('db_host'),
    db_port => $config->get('db_port'),
    db_user => $config->get('db_user'),
    db_pass => $config->get('db_pass'),
  );

  # try 3 times to connect if the connection keeps failing
  for (1..3) {
    $dbh = "FWork::System::DBI::Base::$db_type"->new(%conn_params);
    last if $dbh;
  }
  
  die "Connection to the database failed!\n" if not $dbh;
  
  $dbh->{RaiseError} = 1; # die because of the errors
  
#   if ($config->get('db_utf8')) {
#     $dbh->do('SET NAMES utf8');
#   }
  
# profile all database calls
#  $dbh->{Profile} = "DBI::Profile";
#  DBI->trace(0, 'dbi_prof.txt');

  my $self = $dbh;
  
  my $debug = $config->get('debug_dbi') || $system->in->query('__debug');
  my $enable_read_db = $config->get('enable_read_db');
  
  if ($enable_read_db) {
    %conn_params = (
      db_name => $config->get('read_db_name'),
      db_host => $config->get('read_db_host'),
      db_port => $config->get('read_db_port'),
      db_user => $config->get('read_db_user'),
      db_pass => $config->get('read_db_pass'),    
    );
    
    # try 3 times to connect if the connection keeps failing
    for (1..3) {
      $dbh_read = "FWork::System::DBI::Base::$db_type"->new(%conn_params);
      last if $dbh_read;
    }
    
    if ($dbh_read) {
      $dbh_read->{RaiseError} = 1; # die because of the errors
    } else {
      $enable_read_db = undef if not $dbh_read; 
    }
  }

  # if debug is enabled we create our own proxy object for dbh and then later
  # for sth as well  
  if ($debug or $enable_read_db) {
    require FWork::System::DBIDebug;
    
    tie(my %tiehash, $class . '::Tie') or return undef;
    # __FWork_dbh should always be assigned first, TIEHASH will just disregard
    # any keys before __FWork_dbh is assigned 
    $tiehash{__FWork_dbh} = $dbh;
    $tiehash{__FWork_dbh_read} = $dbh_read;
    $tiehash{__FWork_debug} = $debug;
    
    $self = bless(\%tiehash, $class);
  }
  
  $system->stash(__system_connecting_to_db => undef);
  
  return $self;
}

sub do {
  my $self = shift;
  return undef if not $self->{__FWork_dbh};
  
  my @do_params = @_;
  my $debug = $self->{__FWork_debug};
  my ($bench, $dbh);

  my $query_type = FWork::System::DBIDebug::get_query_type($do_params[0]);
  if ($query_type eq 'select' and $self->{__FWork_dbh_read}) {
    my $query_read_db = 1;
    
    my $skip_read_tables = $system->config->get('skip_read_tables');
    if (ref $skip_read_tables eq 'ARRAY' and @$skip_read_tables) {
      my $exist = FWork::System::DBIDebug::strings_exist_in_query($do_params[0], $skip_read_tables);
      $query_read_db = undef if $exist;
    }
    
    $dbh = $self->{__FWork_dbh_read} if $query_read_db;
  } 
  
  if (not $dbh) {
    $dbh = $self->{__FWork_dbh};
  }  

  if ($debug) {
    $bench = FWork::System::Bench->new;
  }
  
  my $result = $dbh->do(@do_params);
  
  # only do the debugging stuff if debugging is switched on (we could
  # just be in a read database overlay)
  if ($debug) {
    my $exec_secs = $bench->get_raw;;

    my $caller = [caller(0)];
    $caller->[3] = (caller(1))[3];
    
    my $stack;
    
    my $counter = 0;
    while (my @frame = caller($counter)) {
      push @$stack, \@frame;
      $counter += 1;
    }  
    
    my $rows = $self->rows;
    my $query = $do_params[0];
    
    my $stash = $system->stash('__dbi_all_queries') || [];
    push @$stash, {
      'query'   => $query,
      'secs'    => $exec_secs,
      'caller'  => $caller,
      'stack'   => $stack,
      'rows'    => $rows,    
    };
    $system->stash('__dbi_all_queries' => $stash);
  
    my $slow_secs = $system->config->get('slow_query_secs') || 0;
    if ($slow_secs and $exec_secs > $slow_secs) {
      $FWork::System::DBI::UPDATE_LOG->($query, $exec_secs, $rows, $stack);
    }
    
    my $current_total = $system->stash('__dbi_total_queries_time');
    $system->stash('__dbi_total_queries_time' => $current_total + $exec_secs);
  }
  
  return $result;
}

sub prepare {
  my $self = shift;
  return undef if not $self->{__FWork_dbh};
  
  my $debug = $self->{__FWork_debug};
  
  my $sth = FWork::System::DBI::STH->new($self, @_);

  # if debug is not enabled then we return the original DBI sth object at this
  # point
  if ($debug) {
    my $caller = [caller(0)];
    $caller->[3] = (caller(1))[3];
    
    my $stack;
    
    my $counter = 0;
    while (my @frame = caller($counter)) {
      push @$stack, \@frame;
      $counter += 1;
    }
    
    $sth->{__FWork_prepare_caller} = $caller;
    $sth->{__FWork_prepare_stack} = $stack;
  
    # saving the original request
    $sth->{__FWork_query} = $_[0];
  }
  
  return $sth;
}

sub AUTOLOAD { 
  my $self = shift;
  my ($method) = $AUTOLOAD =~ /([^:]+)$/;  
  return undef if not $self->{__FWork_dbh};
  return $self->{__FWork_dbh}->$method(@_);
}

# ============================================================================

package FWork::System::DBI::STH;

use vars qw($AUTOLOAD);
use FWork::System;
# use utf8;

sub new {
  my $class = shift;
  my $s_dbh = shift;
  return undef if not $s_dbh or not ref $s_dbh or not ref $s_dbh->{__FWork_dbh};
  
  my $dbh;
  my $debug = $s_dbh->{__FWork_debug};

  my $query_type = FWork::System::DBIDebug::get_query_type($_[0]);
  if ($query_type eq 'select' and $s_dbh->{__FWork_dbh_read}) {
    my $query_read_db = 1;
    
    my $skip_read_tables = $system->config->get('skip_read_tables');
    if (ref $skip_read_tables eq 'ARRAY' and @$skip_read_tables) {
      my $exist = FWork::System::DBIDebug::strings_exist_in_query($_[0], $skip_read_tables);
      $query_read_db = undef if $exist;
    }
    
    $dbh = $s_dbh->{__FWork_dbh_read} if $query_read_db;
  } 
  
  if (not $dbh) {
    $dbh = $s_dbh->{__FWork_dbh};
  }  
  
  my $sth = $dbh->prepare(@_);
  
  # with no debugging we return the original DBI sth object, 
  # also, no need need to pass debug and dbh_read params further, because
  # if our own sth object is used to do an execute method then this always
  # means that debug is switched on and also that we've already checked
  # the query type and should just use the stored DBH object in our work
  if ($debug){ 
    tie(my %tiehash, $class . '::Tie') or return undef;
    $tiehash{__FWork_sth} = $sth;
    $tiehash{__FWork_dbh} = $dbh;
  
    my $self = bless(\%tiehash, $class);
    return $self;
  } else {
    return $sth;
  }  
}

# this method is only used when debug is switched on, with just read database
# enabled we will never get here because in "prepare" method we will return
# the original DBI sth object
sub execute {
  my $self = shift;
  return undef if not $self->{__FWork_sth};
  
  my @exec_params = @_;
  
  my $slow_secs = $system->config->get('slow_query_secs') || 0;
  my $bench = FWork::System::Bench->new;
  my $result = $self->{__FWork_sth}->execute(@exec_params);
  my $exec_secs = $bench->get_raw;;
  
  my $dbh = $self->{__FWork_dbh};

  my $query = $self->{__FWork_query};
  if (@exec_params) {
    $query =~ s/\?/%s/g;
    $query = sprintf($query, map {$dbh->quote($_)} @exec_params);
  }

  my $rows = $self->rows;
  my $stack = $self->{__FWork_prepare_stack};

  my $stash = $system->stash('__dbi_all_queries') || [];
  push @$stash, {
    'query'   => $query,
    'secs'    => $exec_secs,
    'caller'  => $self->{__FWork_prepare_caller},
    'stack'   => $stack,
    'rows'    => $rows,
  };
  $system->stash('__dbi_all_queries' => $stash);

  if ($slow_secs and $exec_secs > $slow_secs) {  
    $FWork::System::DBI::UPDATE_LOG->($query, $exec_secs, $rows, $stack);
  }
  
  my $current_total = $system->stash('__dbi_total_queries_time');
  $system->stash('__dbi_total_queries_time' => $current_total + $exec_secs);  
  
  return $result;
}

sub AUTOLOAD { 
  my $self = shift;
  my ($method) = $AUTOLOAD =~ /([^:]+)$/;  
  return undef if not $self->{__FWork_sth};
  return $self->{__FWork_sth}->$method(@_);
}

# ============================================================================

package FWork::System::DBI::Tie;
# use utf8;
use Tie::Hash;
use vars qw(@ISA);
@ISA = 'Tie::StdHash';

sub TIEHASH {
  my $class = shift;
  my $self = bless ({}, $class);
  return $self;        
}

sub STORE {
  my ($self, $key, $value) = @_;
  return undef if not $self->{__FWork_dbh} and $key ne '__FWork_dbh';
  if ($key =~ /^__FWork/) {
    return $self->{$key} = $value;
  } else {
    return $self->{__FWork_dbh}->{$key} = $value;
  }
}

sub FETCH {
  my ($self, $key) = @_;
  return undef if not $self->{__FWork_dbh};
  if ($key =~ /^__FWork/) {
    return $self->{$key};  
  } else {
    return $self->{__FWork_dbh}->{$key};      
  }
}

sub DELETE {
  my ($self, $key) = @_;
  return undef if not $self->{__FWork_dbh};  
  if ($key =~ /^__FWork/) {
    return delete $self->{$key};
  } else {
    return delete $self->{__FWork_dbh}->{$key};
  }
}

# ============================================================================

package FWork::System::DBI::STH::Tie;
# use utf8;
use Tie::Hash;
use vars qw(@ISA);
@ISA = 'Tie::StdHash';

sub TIEHASH {
  my $class = shift;
  my $self = bless ({}, $class);
  return $self;        
}

sub STORE {
  my ($self, $key, $value) = @_;
  return undef if not $self->{__FWork_sth} and $key ne '__FWork_sth';
  if ($key =~ /^__FWork/) {
    return $self->{$key} = $value;
  } else {
    return $self->{__FWork_sth}->{$key} = $value;
  }
}

sub FETCH {
  my ($self, $key) = @_;
  return undef if not $self->{__FWork_sth};
  if ($key =~ /^__FWork/) {
    return $self->{$key};  
  } else {
    return $self->{__FWork_sth}->{$key};      
  }
}

sub DELETE {
  my ($self, $key) = @_;
  return undef if not $self->{__FWork_sth};  
  if ($key =~ /^__FWork/) {
    return delete $self->{$key};
  } else {
    return delete $self->{__FWork_sth}->{$key};
  }
}

1;
