use strict;
use FWork::System;
use Digest::MD5 qw(md5_hex);
# use SFCrypt;
use utf8;

sub a {
  my $self = shift;
  my $in = $system->in;
  
  if($in->cookie('key') and $in->cookie('data') and $in->cookie('u')) {
    my $user = $in->cookie('u');
    open(pf, '<' . $system->config->get('password_file'));
    my $users;
    while(my $l = <pf>) {
      my @line = split(':', $l);
      $line[1] =~ s/\n//;
      $users->{$line[0]} = $line[1];
    }
    my $str = uc(md5_hex($in->cookie('data') . $user . $users->{$user} . $system->config->get('password_file')));
    if($in->cookie('key') eq $str) {
      $system->out->redirect('/cgi-bin/index.cgi?pkg=content:a&action=index');
      $system->stop;
    }
  }
  
  if($in->query('login') and $in->query('password')) {
    open(pf, '<' . $system->config->get('password_file'));
    my $users;
    while(my $l = <pf>) {
      my @line = split(':', $l);
      $line[1] =~ s/\n//;
      $users->{$line[0]} = $line[1];
    }
    if(md5_hex($in->query('password')) eq $users->{$in->query('login')}) {
      my $time_key = time();
      $system->out->cookie(
        name    => 'key',
        value   => uc(md5_hex($time_key . $in->query('login') . md5_hex($in->query('password')) . $system->config->get('password_file')))
      );
      $system->out->cookie(
        name    => 'data',
        value   => $time_key
      );
      $system->out->cookie(
        name    => 'u',
        value   => $in->query('login')
      );
      $system->out->redirect('/cgi-bin/index.cgi?pkg=content:a&action=index');
      $system->stop;    
    } else {
      $self->{vars}->{error} = 'yes';
    }
  }

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
