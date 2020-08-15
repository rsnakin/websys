package Forum;
use strict;
use FWork::System;
use Digest::MD5 qw(md5_hex);
use utf8;
use Files;

my $FORUMS = {
  fragen_antworten => {
    name => 'Вопрос-Ответ',
    table_name => 'fragen_antworten'
  }
};

my $AVATAR = {
  '0' => 'female.png',
  '1' => 'male.png'
};


sub new {
  my $class = shift;
  my $forum = shift;
  my $self = bless({}, $class);
  $self->{forum} = $FORUMS->{$forum};
  return undef if not $self->{forum};
  return $self;
}

sub get_message {
  my $self = shift;
  my $mid = shift;
  my $uid = shift;

  my $sth = $system->dbh->prepare('select * from ' . $self->{forum}->{table_name} 
  . ' left join fusers on muid=uid where mid = ?');
  $sth->execute($mid);
  my $msg = $sth->fetchrow_hashref;
  $msg->{site_time} = time() - $msg->{uctime};
  delete $msg->{login};
  delete $msg->{password};
  delete $msg->{uemail};
  delete $msg->{uctime};
  delete $msg->{ultime};
  if($msg->{muid} eq $uid) {
    $msg->{owner} = 'Y';
  }
  if( -e $system->config->get('fusers_avatars') . '/' . $msg->{uid} . '.png') {
    $msg->{avatar} = $system->config->get('fusers_avatars_url') . '/' . $msg->{uid} . '.png';
  } else {
    $msg->{avatar} = $system->config->get('fusers_avatars_url') . '/' . $AVATAR->{$msg->{sex}};
  }
  $msg->{path} = $system->config->get('users_images_path');
  $msg->{url} = $system->config->get('users_images_url');
  my @midarr = split('', $msg->{mid});
  foreach my $s (0..4) {
    $msg->{path} .= '/' . $midarr[$s];
    $msg->{url} .= '/' . $midarr[$s];
  }
  $msg->{path} .= '/' . $msg->{mid};
  $msg->{url} .= '/' . $msg->{mid};
  my $images = Files->new($msg->{path})->get_files_short();
  if($images) {
    foreach my $img (sort {$b->{ctime} <=> $a->{ctime}} @$images) {
      push @{$msg->{images}}, $img;
    }
  }
  # $msg->{images} = Files->new($msg- >{path})->get_files_short();
  # delete $msg->{path};
  # $system->dump($msg, file => '/var/www/msg.dump');
  return($msg);
}

sub delete_msg {
  my $self = shift;
  my $mid = shift;
  my $muid = shift;

  my $sth = $system->dbh->prepare('delete from ' . $self->{forum}->{table_name} . ' where mid = ? and muid = ?');
  $sth->execute($mid, $muid);

}

sub get_messages {
  my $self = shift;
  my $in = {
    start => undef,
    page => undef,
    uid => undef,
    @_
  };

  $in->{start} = '0' if not $in->{start};

  my $sth;
  if(not $in->{uid}) {
    $sth = $system->dbh->prepare('select * from ' . $self->{forum}->{table_name} 
    . ' left join fusers on muid=uid where locked is null order by mtime desc limit ' . $in->{start} . ', ' . $in->{page});
    $sth->execute();
  } else {
    $sth = $system->dbh->prepare('select * from ' . $self->{forum}->{table_name} 
    . ' left join fusers on muid=uid left join msg_reader on rmid = mid and ruid = ? order by mtime desc limit ' 
    . $in->{start} . ', ' . $in->{page});
    $sth->execute($in->{uid});
  }
  my $pathImg = $system->config->get('users_images_path');
  my $urlImg = $system->config->get('users_images_url');
  
  while(my $msg = $sth->fetchrow_hashref) {
	  delete $msg->{login};
	  delete $msg->{password};
	  delete $msg->{uemail};
	  delete $msg->{uctime};
	  delete $msg->{ultime};
	  if( -e $system->config->get('fusers_avatars') . '/' . $msg->{uid} . '.png') {
		$msg->{avatar} = $system->config->get('fusers_avatars_url') . '/' . $msg->{uid} . '.png';
	  } else {
		$msg->{avatar} = $system->config->get('fusers_avatars_url') . '/' . $AVATAR->{$msg->{sex}};
	  }
	  $msg->{path} = $pathImg;
	  $msg->{url} = $urlImg;
	  my @midarr = split('', $msg->{mid});
	  foreach my $s (0..4) {
		$msg->{path} .= '/' . $midarr[$s];
		$msg->{url} .= '/' . $midarr[$s];
	  }
	  $msg->{path} .= '/' . $msg->{mid};
	  $msg->{url} .= '/' . $msg->{mid};
	  my $images = Files->new($msg->{path})->get_files_short();
	  if($images) {
		foreach my $img (sort {$b->{ctime} <=> $a->{ctime}} @$images) {
		  push @{$msg->{images}}, $img;
		}
	  }
	  delete $msg->{path};
	  push @{$self->{msg_page}}, $msg;
  }

# $system->dump($self->{msg_page}, file => '/var/www/msg.test');
    
  if(not $self->{msg_page}) {
    return [];
  } else {
    return $self->{msg_page};
  }
}

sub date_prepare {
  my $self = shift;
  my $date = shift;

  my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($date);
  return sprintf("%02d.%02d.%4d %02d:%02d", $mday, $mon + 1, $year + 1900, $hour, $min);
}


sub get_id {
  my $self = shift;
  return uc(md5_hex(localtime()) . md5_hex(rand()));
}

sub update_message {
  my $self = shift;
  my $in = {
    mid => undef,
    mbody => undef,
    maid => undef,
    @_
  };
 
  my $sth = $system->dbh->prepare('update ' . $self->{forum}->{table_name} 
  . ' set mbody = ?, maid = ?, mutime = unix_timestamp(now()) where mid = ?');
  $sth->execute(
    $in->{mbody},
    $in->{maid},
    $in->{mid}
  );
}


sub add_message {
  my $self = shift;
  my $in = {
    mid => undef,
    muid => undef,
    mbody => undef,
    maid => undef,
    lock => undef,
    @_
  };
 
 	$system->dump($in, file => '/var/www/add_message.dump');
 	
  my $lock = undef;
  if($in->{lock}) {
  	$lock = 'Y';
  }
  my $sth = $system->dbh->prepare('insert into ' . $self->{forum}->{table_name} 
  . ' set mid = ?, muid = ?, mbody = ?, maid = ?, locked = ?, mtime = unix_timestamp(now())');
  $sth->execute(
    $in->{mid},
    $in->{muid},
    $in->{mbody},
    $in->{maid},
    $lock
  );
}


sub get_users {
  my $self = shift;
  my $sth = $system->dbh->prepare('select * from fusers');
  $sth->execute();
  while(my $u = $sth->fetchrow_hashref) {
    push @{$self->{users}}, $u;
  }
  return $self->{users};
}

sub logout_user {
  my $self = shift;
  my $cookie = shift;

  unlink($system->config->get('fusers') . '/' . $cookie);
}

sub check_login_user {
  my $self = shift;
  my $cookie = shift;

  if( -e $system->config->get('fusers')) {
    open(ifl, '<'. $system->config->get('fusers') . '/' . $cookie) || return undef;
    my $udata;
    while(my $l = <ifl>) {
      $udata .= $l;
    }
    my $u = from_json($udata);
    if($u->{key} eq $cookie) {
      return $u;
    } else {
      return undef;
    }
  } else {
    return undef;
  }

}

sub login_user {
  my $self = shift;
  my $in = {
    login => undef,
    password => undef,
    @_
  };

  my $sth = $system->dbh->prepare('select * from fusers where login = ? and password = ? and appl = ?');
  $sth->execute($in->{login}, md5_hex($in->{password}), 'Y');

  require FWork::System::Utils;
  require FWork::System::File;

  my $u = $sth->fetchrow_hashref;

  $u->{key} = $self->get_id();

  if($u->{uid}) {
    FWork::System::Utils::create_dirs($system->config->get('fusers'));
    use JSON -support_by_pp;
    open(ifl, '>'. $system->config->get('fusers') . '/' . $u->{key});
    print ifl to_json($u);
    close(ifl);
    return($u);
  } else {
    return undef;
  }
}

sub check_email {
  my $self = shift;
  my $email = shift;

  my $sth = $system->dbh->prepare('select * from fusers where uemail = ?');
  $sth->execute($email);
  if($sth->fetchrow_hashref) {
    return {status => 'exists'};
  }
  return {status => 'none'};
}

sub check_login {
  my $self = shift;
  my $login = shift;

  my $sth = $system->dbh->prepare('select * from fusers where login = ?');
  $sth->execute($login);
  if($sth->fetchrow_hashref) {
    return {status => 'exists'};
  }
  return {status => 'none'};
}

sub add_user {
  my $self = shift;
  my $in = {
    uname => undef,
    uvorname => undef,
    uemail => undef,
    login => undef,
    password => undef,
    sex => undef,
    @_
  };
 
  $self->{error} = undef;

  my $sth = $system->dbh->prepare('select * from fusers where login = ?');
  $sth->execute($in->{login});
  if($sth->fetchrow_hashref) {
    $self->{error} = 'login_exists';
    return undef;
  }
  my $sth = $system->dbh->prepare('select * from fusers where uemail = ?');
  $sth->execute($in->{uemail});
  if($sth->fetchrow_hashref) {
    $self->{error} = 'email_exists';
    return undef;
  }
  my $sth = $system->dbh->prepare('select * from fusers where uname = ? and uvorname = ?');
  $sth->execute($in->{uname}, $in->{uvorname});
  if($sth->fetchrow_hashref) {
    $self->{error} = 'name_exists';
    return undef;
  }

  my $uid = $self->get_id();
  my $pwd = md5_hex($in->{password});

  my $sth = $system->dbh->prepare('insert into fusers'
  . ' set uid = ?, uname = ?, uvorname = ?, uemail = ?, login = ?, rate = 0, password = ?, sex = ?, uctime = unix_timestamp(now()), ultime = unix_timestamp(now())');
  $sth->execute(
    $uid,
    $in->{uname},
    $in->{uvorname},
    $in->{uemail},
    $in->{login},
    $pwd,
    $in->{sex}
  );

  return($uid);
}

sub update_reader {
  my $self = shift;
  my $in = {
    rmid => undef,
    ruid => undef,
    @_
  };

  my $sth = $system->dbh->prepare('select * from msg_reader where rmid = ? and ruid = ?');
  $sth->execute($in->{rmid}, $in->{ruid});
  if(not $sth->fetchrow_hashref) {
	my $sth = $system->dbh->prepare('insert into msg_reader set rtime = unix_timestamp(now()), rmid = ?, ruid = ?');
	$sth->execute($in->{rmid}, $in->{ruid});
	my  $sth = $system->dbh->prepare('update fragen_antworten set readed = readed + 1 where mid = ?');
    $sth->execute($in->{rmid});
  }
  return;
}

1;
__END__

CREATE TABLE `fragen_antworten` (
  `mid` varchar(64),
  `muid` varchar(64),
  `mtime` int(20) unsigned NOT NULL,
  `mbody` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8

alter table fragen_antworten add `maid` varchar(64) default NULL
alter table fragen_antworten add `mutime` int(20) unsigned default NULL,
alter table fragen_antworten add `readed` int(20) unsigned default 0,
alter table fragen_antworten add `locked` varchar(1) default NULL

CREATE TABLE `fusers` (
  `uid` varchar(64),
  `uname` varchar(128),
  `uvorname` varchar(128),
  `uemail` varchar(128),
  `login` varchar(16),
  `rate` int(20),
  `uctime` int(20) unsigned NOT NULL,
  `ultime` int(20) unsigned NOT NULL,
  `password` varchar(32)
) ENGINE=MyISAM DEFAULT CHARSET=utf8
alter table fusers add appl varchar(1) default null;
alter table fusers add sex varchar(1);

CREATE TABLE `msg_reader` (
  `rmid` varchar(64),
  `ruid` varchar(64),
  `rtime` int(20) unsigned NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8


