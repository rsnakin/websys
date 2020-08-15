package FWork::System::Error::Web;

$VERSION = 1.00;

use strict;

use FWork::System;

sub new {
  my $class = shift;
  my $in = {
    container => undef, # FWork::System::Error instance
    pkg       => undef,
    action    => undef,
    form      => undef, # optional
    @_
  };  
  
  foreach (qw(container)) {
    return undef if false($in->{$_});
  }

  my $self = bless($in, $class);                                              
  return $self; 
}

# Method: announce
#
# Announces an error to the system exactly the same way as <throw> does it, but
# doesn't launch any action at the end, just returns back to the calling code
# after the error was announced.
#
# Parameters:
#
# Same is in <throw> method.

sub announce {
  my $self = shift;
  my $in = {
    message    => undef, # message text
    msg_id     => undef, # i18n message id
    msg_params => undef, # i18n message params, ARRAY ref
    fields     => undef, # ARRAY ref
    @_
  };

  $self->throw(%$in, _no_launch => 1);
}

# Method: throw
#
# Adds a specified error to the errors container so that it becomes visible
# to any code that wants to check if there was an error and launches an
# action that was specified when the error was setup.
#
# If you don't want to launch an action and want to handle the error situation
# yourself (but you still want to tell the system that there was an error) -- 
# look at the <announce> method instead.
#
# Parameters:
#
# message - error message text
# msg_id - i18n text id if you want to look up the actual message text in a 
# language file
# msg_params - ARRAY ref, parameters that you want to pass to i18n routine
# fields - ARRAY ref, erroneous form fields, that should be marked in the
# template

sub throw {
  my $self = shift;
  my $in = {
    message     => undef, # message text
    msg_id      => undef, # i18n message id
    msg_params  => undef, # i18n message params, ARRAY ref
    fields      => undef, # ARRAY ref
    _no_launch  => undef, # internal param, not for public use
    @_
  };

  if (not $in->{_no_launch}) {
    foreach (qw(pkg action)) {
      return undef if false($self->{$_});
    }
  }

  $self->{fields} = $in->{fields};

  # i18n
  if (true($in->{msg_id})) {
    my @params = ref $in->{msg_params} eq 'ARRAY' ? @{$in->{msg_params}} : undef;
    my $errors = $self->{pkg}->_language->load('_system/errors.cgi');
    my $string = $errors->get($in->{msg_id}, @params);
    $self->{message} = true($string) ? $string : $in->{msg_id};
  } 
  
  # plain message
  else {
    $self->{message} = $in->{message};
  }

  # saving error in the container before throwing
  $self->{container}->_save_error($self);

#  $self->{container}->warn($system->dump($self, return => 1));  
#  $self->{container}->warn($system->dump($system->in, return => 1));

  if (not $in->{_no_launch}) {
    my $action = $self->{action}; 
    $self->{pkg}->$action();
  }
}

sub form { $_[0]->{form} }
sub message { $_[0]->{message} }
sub fields { $_[0]->{fields} }

1;