package FWork::System;

# FWork System global version
$VERSION = 3.18;

use strict;
use vars qw($system @ISA @EXPORT);
use FWork::System::True;

# in case this file was loaded directly somewhere we load CGI::Carp again
# (there should be no speed penality for us if this was already done in 
# index.cgi)
use CGI::Carp qw(fatalsToBrowser);

require Exporter; @ISA = qw(Exporter); @EXPORT = qw($system &true &false);

# Constructor: new
# Initiates <FWork::System> object
#
# Parameters:
# 1st - physical path of the main FWork System directory, where index.cgi
#       file is located and where we expect to find *private* directory
#
# Returns:
# <FWork::System> object.

sub new {
  my ($class, $sys_path, $pkg_path) = @_;
  return undef if not defined $sys_path;
  $pkg_path = $sys_path if not defined $pkg_path;
  $system = bless({
    _sys_path => $sys_path,
    _pkg_path => $pkg_path,
  }, $class);
  $system->_init;
  
  if ($system->config->get('system_stopped') and not $ENV{STUFFED_IGNORE_SYSTEM_STOP}) {
    # disabling all system events
    my $events = $system->stash('__disabled_events');
    $events->{system}->{__all} = 1;
    $system->stash(__disabled_events => $events);
    
    $system->pkg('system')->stopped;
    $system->stop;
  }
  return $system;
}

# Method: run
# Launches FWork System, it is usually called right after the <new> method.

sub run {
  my $self = shift;

  # always initializing system package to process 'startup' event for the 
  # whole system before anything else
  $self->pkg('system');

  my $pkg = $self->in->query('pkg') || $self->{_config}->get('default_pkg');
  die "No suitable packages were found! You need to specify a package name in order to proceed!\n" if false($pkg);
  $self->pkg($pkg)->_run;
  return $self;
}

sub pkg {
  my $self = shift;
  my $pkg = shift;
  return if false($pkg);

  # if package is not initialized we do it
  if (not $self->{_pkgs}->{$pkg}) {
    $pkg =~ s/^[:]+|[:]$//g;
    (my $package = $pkg) =~ s/:/::/g; 
    # removing forbiden characters
    $package =~ s/[^\w:]/_/g;
    eval <<CODE;
package FWork::System::Package::$package; 
use base qw(FWork::System::Package); 
use FWork::System;
CODE
    die $@ if $@;
    "FWork::System::Package::$package"->_new;
  }

  return $self->{_pkgs}->{$pkg};
}

sub stash {
  my $self = shift;
  my $key = shift;
  $self->{_stash}->{$key} = shift if scalar @_;
  return $self->{_stash}->{$key};
}

sub _save_pkg {
  my $self = shift;
  my $pkg = shift;
  return undef if not $pkg;
  $self->{_pkgs}->{$pkg->_name} = $pkg;
}

sub _init {
  my $self = shift;

  if (not -r "$self->{_sys_path}/private/system/config/config.cgi") {
    die "Critical error! System configuration file is missing! [$self->{_sys_path}/private/system/config/config.cgi]\n";
  }
  
  # setting our own error handler via CGI::Carp interface, should be done
  # after checking config, otherwise die above won't work as it relies on
  # FWork::System::Output which itself relies on the presence of the system
  # config.
  require FWork::System::Error;
  $self->{error} = FWork::System::Error->new;
  CGI::Carp::set_message(\&FWork::System::Error::_just_die);  

  # loading system configuration
  require FWork::System::Config;
  $self->{_config} = FWork::System::Config->new("$self->{_sys_path}/private/system/config/config.cgi");
  
  # starting benchmark timer
  require FWork::System::Bench;
  $self->{_bench} = FWork::System::Bench->new;

  require FWork::System::File;
  require FWork::System::Package;
  require FWork::System::Utils;

  # removing all restrictions from the access rights mask
  umask 0000;
  
  return $self;
}

sub dbh {
  my $self = shift;
  return $self->{dbh} if $self->{dbh};
  require FWork::System::DBI;
  return $self->{dbh} = FWork::System::DBI->new;
}

sub in {
  my $self = shift;
  return $self->{in} if $self->{in};
  require FWork::System::Input;
  return $self->{in} = FWork::System::Input->new;
}

sub out {
  my $self = shift;
  return $self->{out} if $self->{out};
  require FWork::System::Output;
  return $self->{out} = FWork::System::Output->new;
}

sub user {
  my $self = shift;
  return $self->{user} if $self->{user};
  require FWork::System::User;
  return $self->{user} = FWork::System::User->new;
}

sub session {
  my $self = shift;
  return $self->{session} if $self->{session};
  require FWork::System::Session;
  return $self->{session} = FWork::System::Session->new;
}

sub path     { 
  my ($self, $type) = @_;
  $type eq 'pkg' ? $self->{_pkg_path} : $self->{_sys_path};
}

sub config { $_[0]->{_config} }
sub error  { $_[0]->{error} }
sub dump   { shift; FWork::System::Utils::dump(@_) }
sub on_destroy {
  my ($self, $code) = @_;
  return undef if not $code;
  push @{$self->{on_destroy}}, $code;
}

sub stop {


  my $self = shift;
  my $in = {
    die_completely => undef, # optional, under mod_perl will terminate the current
                             # process completely, should be used when called by
                             # a child after the fork 
    @_
  }; 

  # processing 'system_stop' event
  $self->pkg('system')->_event('system_stop')->process(pkg => $self);

  # only output if debug is switched on and there was some output beforehand
  # we need output beforehand to escape the situation when CGI::Carp has 
  # already printed out an error
  if ($self->{_config}->get('debug') and $self->out->output and $self->out->context eq 'web') {
    my $content = qq(<script language="javascript"><!--\n);
    $content .= qq(defaultStatus = ');
    $content .= 'Processing time: '.$self->{_bench}->get_raw.'. ' if $self->{_bench};
    $content .= 'Mod_perl enabled. ' if $ENV{MOD_PERL};
    $content .= 'Gzip enabled.' if $self->out->gzip;
    $content .= qq(';\n//--></script>);
    $self->out->say($content);
  }

  # disconnect from the database if we were connected
  $self->dbh->disconnect if $self->{dbh};
#	    return;
  
  # destroyong system and all initialized objects
#  undef $system;
#    $system = undef;
  
  CORE::exit() if not $ENV{MOD_PERL} or $in->{die_completely};
  undef $system;
  
  # mod_perl 2.0
  if (exists $ENV{MOD_PERL_API_VERSION} && $ENV{MOD_PERL_API_VERSION} == 2) {
    ModPerl::Util::exit();
  } 
  # mod_perl 1.0
  else {
    Apache::exit();
  }
}

sub DESTROY {
  my $self = shift;
  return if ref $self->{on_destroy} ne 'ARRAY';
  
  delete $self->{$_} for grep {$_ ne 'on_destroy'} keys %$self;
  $_->() for @{$self->{on_destroy}};
}

1;

__END__

=head1 NAME

FWork::System - The main class of the FWork Framework.

=head1 CAVEATS

Currently we load configuration for the 'system' package before we load 
the system package itself. This leads to a rather strange situation when
the same config is stored in two places: in the 'system' package and in 
the FWork::System object. Right now, the author of this class doesn't see 
how this can make things to go wrong. 

Since config files are cached when they are loaded, the 'system' package 
config and FWork::System class config will effectively be the same config 
object.

=cut