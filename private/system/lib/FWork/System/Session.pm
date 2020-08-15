package FWork::System::Session;

$VERSION = 1.00;

use strict;

use FWork::System;

sub new {
  my $class = shift;
  my $db_type = $system->config->get('db_type');

  if (not eval "require FWork::System::Session::$db_type") {
    die $@ if $@;
    die "Database type '$db_type' is not supported by the Session class in this installation of FWork System!\n";
  }

  my $in = $system->in;
  my $config = $system->config;
 
  my $self = bless({clean => undef}, "FWork::System::Session::$db_type");
  
  $self->{ip} = sprintf("%02x%02x%02x%02x", split(/\./, $ENV{REMOTE_ADDR} || '0.0.0.0'));

  # default settings
  $self->{settings} = {
    # 1 hour
    sessions_lifetime     => 3600, 
    # 1 - store ip in cookie in case of dynamic ip changing, 0 - do not
    sessions_ip_in_cookie => 1,    
    table                 => $config->get('db_prefix').'system_sessions'
  };
  
  foreach (qw(sessions_lifetime sessions_ip_in_cookie)) {
    $self->{settings}->{$_} = $config->get($_) if true($config->get($_));
  }

  # creating unique signature for the current user
  $self->{signature} = $self->_create_signature;

  # if storing ip in cookie is switched on and there IS an ip in the cookie we
  # create an alternative signature for the user
  if ($self->{settings}->{sessions_ip_in_cookie} and $in->cookie('user_ip')) {
    $self->{signature_cookie} = $self->_create_signature($in->cookie('user_ip'));
  }

  # checking if session id was passed via url and if it is legal
  if ($in->query('sid')) {
    $self->_check_session($in->query('sid'));
  }

  # checking if session id was passed via cookies and if it is legal
  if (not $self->is_valid and $in->cookie('sid')) {
    $self->_check_session($in->cookie('sid'));
  }
  
  return $self;
}

sub id { $_[0]->{id} }
sub is_valid { true($_[0]->{id}) ? 1 : 0 }
sub id_for_url { "sid=$_[0]->{id}" }
sub get_content { $_[0]->{content} }; 

sub is_new {
  my $self = shift;
  $self->_create_session if not $self->is_valid; 
  return $self->{__just_created}; 
}

sub get {
  my ($self, $key) = @_;
  return if not $self->{content};
  return keys %{$self->{content}} if false($key);
  return $self->{content}->{$key};
}

sub _create_signature { 
  my ($self, $use_ip) = @_;
  (my $browser = $ENV{HTTP_USER_AGENT} || '') =~ s/\s+//g;
  # signature should be at least 100 characters long
  return substr(($use_ip || $self->{ip}).$browser, 0, 99);
}

# adding specified data to existing session content
sub add {
  my ($self, $data) = (shift, {@_});
  return if not %$data;
  
  $self->_create_session if not $self->is_valid;
  $self->{content}->{$_} = $data->{$_} foreach keys %$data;
  
  return $self->_update_session;
}

# replacing existing session content with the new data
sub save {
  my ($self, $data) = (shift, {@_});
  return if not %$data;

  $self->_create_session if not $self->is_valid;
  $self->{content} = $data;

  return $self->_update_session;
}

# excepts multiple keys
sub delete {
  my ($self, @keys) = (@_);
  return $self if not $self->is_valid or not @keys or not $self->{content};

  delete $self->{content}->{$_} foreach @keys;

  return $self->_update_session;
}

sub _unpack {
  my ($self, $string) = @_;
  
  require Storable;
  return Storable::thaw($string);
}

sub _pack {
  my ($self, $content) = @_;
  $content ||= $self->{content};
  return if not $content or not ref $content;
    
  require Storable;
  return Storable::nfreeze($content);
}

1;