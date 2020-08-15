package FWork::System::Event;

$VERSION = 1.00;

use strict;

use FWork::System;

sub new { 
  my $class = shift;
  my $in = {
    name => undef, # name of the event to initialize
    pkg  => undef, # package object
    @_
  };
  my $name = $in->{name};
  my $pkg = $in->{pkg};
  return if false($name) or false($pkg);

  my $self = bless({
    name    => $name, # name of the event
    pkg     => $pkg,
    file    => $pkg->_path.'/events/'.$name,
    listed  => [],    # listed plugins in the event file
    plugins => [],    # actually compiled plugins for this event
  }, $class);

  my $disabled_events = $system->stash('__disabled_events');
  # all events in the current package are disabled
  return $self if $disabled_events->{$pkg->_name}->{__all};
  # current event in the current package is disabled
  return $self if $disabled_events->{$pkg->_name}->{$name};
  
  # we load the event file or return if we can't open it
  my $file = FWork::System::File->new($self->{file}, 'r') || return $self;
  while (my $line = $file->line) {
    # cleaning the line
    chomp($line); $line =~ s/^\s+//g; $line =~ s/\s+$//g;
    next if false($line) or substr($line, 0, 1) eq '#';
    push @{$self->{listed}}, $line;
  }
  $file->close;
  
  my $cache = $system->stash('_plugins_cache') || {};

  # trying to compile all listed plugins
  foreach my $plugin (@{$self->{listed}}) {
    if (not $cache->{$plugin}) {
      my $code = $self->_compile_plugin($plugin);
      next if ref $code ne 'CODE';
      $cache->{$plugin} = $code;
    }

    push @{$self->{plugins}}, {name => $plugin, code => $cache->{$plugin}};
  }

  $system->stash(_plugins_cache => $cache);
                                                 
  return $self;
}

sub process {
  my ($self, @params) = @_;
  
  foreach my $plugin (@{$self->{plugins}}) {
    $plugin->{code}->(@params);
  }

  return @params;
}

sub name { $_[0]->{name} }
sub has_plugins { @{$_[0]->{plugins}} ? 1 : 0 }
sub list_plugins { my $self = shift; map {$_->{name}} @{$self->{plugins}} }

sub _compile_plugin {
  my ($self, $plugin) = @_;
  return if false($plugin);

  my ($pkg, $p_name) = $plugin =~ /^(.+?):([^:]+)$/;
  my $p_file = $system->path.'/private/'.FWork::System::Package->_create_path($pkg)."/plugins/$p_name.cgi";
  return if not -r $p_file;

  my $package = "FWork::System::Plugins::$pkg";

  eval <<CODE;
package $package; 
use FWork::System;
require "$p_file";
CODE
  die "Error compiling plugin $plugin: $@" if $@;
  return if not defined &{$package.'::'.$p_name};

  return \&{$package.'::'.$p_name};
}

1;

__END__

=head1 NAME

FWork::System::Event - Events framework, the basis for the FWork System plugins.

=head1 SYNOPSIS

  use FWork::System::Event;
  my $event = FWork::System::Event->new(pkg => $self, name => 'autoload');
  $event->process($some_data);
  
  if ($event->has_plugins) {
    foreach my $plugin ($event->list_plugins) {
      print "plugin: $plugin\n";
    } 
  } else {
    print 'No plugins are attached to the event "'.$event->name.'"!"';
  }

=head1 DESCRIPTION

Format of the plugins list in the event file is as follows:

  package:name:plugin_name

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=cut