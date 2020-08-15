package FWork::System::Session::MySQL;

$VERSION = 1.00;

use strict;

use FWork::System;
use base qw(FWork::System::Session);

sub expire {
  my ($self, $id) = @_;
  $id ||= $self->{id};
  return if false($id);

  my $sth = $system->dbh->prepare("delete from $self->{settings}->{table} where id = ?");
  $sth->execute($id); 
  $sth->finish;

  # clearing the session object
  $self->{$_} = '' foreach (qw(id session content));

  # deleting sid cookie
  $system->out->cookie(name => 'sid', value => '', expires => '-30d');

  # deleting current user ip in the cookie if this option is switched on
  if ($self->{settings}->{sessions_ip_in_cookie}) {
    $system->out->cookie(name => 'user_ip', value => '', expires => '-30d');
  }

  return $self;
}

sub _cleanup {
  my $self = shift;
  return if $self->{clean};
  my $target_time = time - $self->{settings}->{sessions_lifetime};
  $system->dbh->do("delete from $self->{settings}->{table} where used < $target_time");
  $self->{clean} = 1;
}

sub _update_session {
  my $self = shift;
  return if not $self->is_valid or false($self->{content});

  my $sth = $system->dbh->prepare("update $self->{settings}->{table} set used = unix_timestamp(now()), content = ? where id = ?");
  $sth->execute($self->_pack, $self->{id});
  $sth->finish;

  return $self;
}

sub _create_session {
  my $self = shift;
  $self->{id} = FWork::System::Utils::create_random(32);

  my $sth = $system->dbh->prepare("insert into $self->{settings}->{table} set id = ?, used = unix_timestamp(now()), signature = ?");
  $sth->execute($self->{id}, $self->{signature});
  $sth->finish;
 
  $system->out->cookie(name => 'sid', value => $self->{id}, expires => '+'.$self->{settings}->{sessions_lifetime}.'s');

   # saving current user ip in the cookie if this option is switched on
  if ($self->{settings}->{sessions_ip_in_cookie}) {
    $system->out->cookie(name => 'user_ip', value => $self->{ip}, expires => '+'.$self->{settings}->{sessions_lifetime}.'s');
  }
  
  $self->{__just_created} = 1;

  return $self;
}

sub _check_session {
  my ($self, $id) = @_;
  return $self if not $id;

  # it should be enough to do the cleanup when a session id is checked
  $self->_cleanup;

  my $sth = $system->dbh->prepare("select * from $self->{settings}->{table} where id = ?");
  $sth->execute($id);
  my $session = $sth->fetchrow_hashref;

  return $self if not $session;

  if ($self->{signature} ne $session->{signature}) {
    if ($self->{settings}->{sessions_ip_in_cookie} and $self->{signature_cookie}) {
      return $self if $self->{signature} ne $session->{signature_cookie};
    } else {
      return $self;
    }
  }

  $self->{content} = $self->_unpack($session->{content});
  $self->{session} = $session;
  $self->{id} = $id;

  # session was successfully initialized, we renew its last usage time
  $sth = $system->dbh->prepare("update $self->{settings}->{table} set used = unix_timestamp(now()) where id = ?");
  $sth->execute($id);
  $sth->finish;

  $system->out->cookie(name => 'sid', value => $id, expires => '+'.$self->{settings}->{sessions_lifetime}.'s');

  # saving current user ip in the cookie if this option is switched on
  if ($self->{settings}->{sessions_ip_in_cookie}) {
    $system->out->cookie(name => 'user_ip', value => $self->{ip}, expires => '+'.$self->{settings}->{sessions_lifetime}.'s');
  }

  return $self;
}

1;