use strict;
use FWork::System;
use utf8;
use SFCrypt;
use Digest::MD5 qw(md5_hex);

sub _init {
  my $self = shift;
  my $in = $system->in;

  if($in->cookie('key') and $in->cookie('data') and $in->cookie('u')) {
    my $user = SFCrypt->new($in->cookie('u'))->decrypt();
    open(pf, '<' . $system->config->get('password_file'));
    my $users;
    while(my $l = <pf>) {
      my @line = split(':', $l);
      $line[1] =~ s/\n//;
      $users->{$line[0]} = $line[1];
    }
    my $str = uc(md5_hex($in->cookie('data') . $user . $users->{$user} . $system->config->get('password_file')));
    if($in->cookie('key') ne $str) {
      $system->out->cookie(
        name    => 'key',
        value   => '',
        expires => '-30d'
      );
      $system->out->cookie(
        name    => 'data',
        value   => '',
        expires => '-30d'
      );
      $system->out->cookie(
        name    => 'u',
        value   => '',
        expires => '-30d'
      );
      $system->out->redirect('/admin.html');
      $system->stop;
    }
  }

}

1;
