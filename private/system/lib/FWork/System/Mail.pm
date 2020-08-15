package FWork::System::Mail;

$VERSION = 1.00;

use strict;

use Time::Local;
use Socket;
use FWork::System;

my $defaults = {
  retries        => 1, # number of retries while connecting to smtp server
  delay          => 1, # delay in seconds between retries
  encode_message => 1, # encode message with mime (if the module is available)
  mail_system    => 'smtp',              # can also be 'sendmail'
  smtp_server    => 'localhost',         # smtp server
  smtp_port      => 25,                  # smtp server port
  sendmail_path  => '/usr/sbin/sendmail', # path to sendmail
};

sub new {
  my $class = shift;
  my $self = {
    from    => undef,
    to      => [],
    subject => undef,
    message => undef,
    content => undef, # if you want to set subject as a part of message (using templates) - use "content" instead of "message"
    header  => {},
    @_  
  };
  return undef if false($self->{to});
  return undef if false($self->{from});
  return undef  if not $self->{content} and not $self->{message};
  $self->{to} = [$self->{to}] if ref $self->{to} ne 'ARRAY';
  
  # checking if we've got any empty to's now
  my $to_confirmed;
  foreach my $to (@{$self->{to}}) {
    next if false($to);
    push @$to_confirmed, $to;
  }
  return undef if not $to_confirmed; 
  $self->{to} = $to_confirmed;

  $self = bless($self, $class);

  my $config = $system->config;
 
  $self->{mail_system} = true($config->get('mail_system')) ? $config->get('mail_system') : $defaults->{mail_system};

  if ($self->{mail_system} eq 'smtp') {
    $self->{smtp_server} = true($config->get('smtp_server')) ? $config->get('smtp_server') : $defaults->{smtp_server};
    $self->{smtp_port}   = true($config->get('smtp_port')) ? $config->get('smtp_port') : $defaults->{smtp_port};

    # extract port if server name like "mail.domain.com:2525"
    $self->{smtp_port} = $1 if $self->{smtp_server} =~ s/:(\d+)$//o;
  } else {
    $self->{sendmail_path} = true($config->get('sendmail_path')) ? $config->get('sendmail_path') : $defaults->{sendmail_path};    
  }

  my ($date) = map {$self->{header}->{$_}} grep {$_ =~ /^date$/i} keys %{$self->{header}};
  $self->{header}->{'Date'} = $date || $self->_time_to_date;

  my ($mime) = map {$self->{header}->{$_}} grep {$_ =~ /^mime-version$/i} keys %{$self->{header}};
  $self->{header}->{'MIME-Version'} = $mime || '1.0';

  my ($type) = map {$self->{header}->{$_}} grep {$_ =~ /^content-type/i} keys %{$self->{header}};
  $self->{header}->{'Content-Type'} = $type || 'text/plain; charset="utf-8"'; #'text/plain; charset="iso-8859-1"';

# russian encoding
# $in{header}->{'Content-type'} ||= 'text/plain; charset="windows-1251"';

  if ($defaults->{encode_message}) {
    eval("use MIME::QuotedPrint");
    $self->{mime} &&= (!$@);
  }

  if ($self->{content}) {
    $self->{content} =~ s/^Subject:\s*(.+?)[\015\012]+//is;
    $self->{subject} = $1;
    $self->{message} = $self->{content};
  }

  # cleanup message, and encode if needed
  $self->{message} =~ s/\r\n/\n/go;  # normalize line endings, step 1 of 2 (next step after MIME encoding)

  if ($defaults->{encode_message} and 
      not $self->{header}->{'Content-Transfer-Encoding'}
      and $self->{header}->{'Content-Type'} !~ /multipart/io)
  {
    if ($self->{mime}) {
      $self->{header}->{'Content-Transfer-Encoding'} = 'quoted-printable';
      $self->{message} = encode_qp($self->{message});
    } else {
      $self->{header}->{'Content-Transfer-Encoding'} = '8bit';
    }
  }
  
  $self->{message} =~ s/\n/\015\012/go; # normalize line endings, step 2.
  
  return $self;
}

sub send {
  my $self = shift;
  return $self->_smtp if $self->{mail_system} eq 'smtp';
  return $self->_sendmail if $self->{mail_system} eq 'sendmail';
}

sub _sendmail {
  my $self = shift;
 
  foreach my $to (@{$self->{to}}) {
    open (MAIL,"|". $self->{sendmail_path} . " -t -f $self->{from}");

    print MAIL "To: $to\n";
    print MAIL "From: $self->{from}\n";

    foreach my $header (keys %{$self->{header}}) { 
      print MAIL "$header: $self->{header}->{$header}\n";
    }

    print MAIL "Subject: $self->{subject}\n\n";
    print MAIL $self->{message};

    close MAIL;
  }

  return 1;
}

sub _smtp {
  my $self = shift;

  sub fail {
    $self->{error} .= join(" ", @_) . "\n";
    close S;
    return;
  }

  local $_;
  local $/ = "\015\012";

  # get local hostname for polite HELO
  my $localhost = (gethostbyname('localhost'))[0] || 'localhost';

  unless (socket S, AF_INET, SOCK_STREAM, (getprotobyname 'tcp')[2] ) {
    return fail("socket failed ($!)");
  }

  my $smtpaddr = inet_aton($self->{smtp_server}) || return fail("$self->{smtp_server} not found\n");

  my $retried = 0; my $connected;
  while ((not $connected = connect S, pack_sockaddr_in($self->{smtp_port}, $smtpaddr))
          and ($retried < $defaults->{retries})) 
  {
    $retried++; 
    $self->{error} .= "connect to $self->{smtp_server} failed ($!)\n";
    sleep $defaults->{delay};
  }

  return fail("connect to $self->{smtp_server} failed ($!) no (more) retries!") if not $connected;

  my ($oldfh) = select(S); $| = 1; select($oldfh);

  chomp($_ = <S>);
  return fail("Connection error from $self->{smtp_server} on port $self->{smtp_port} ($_)") if /^[45]/ or !$_;

  print S "HELO $localhost\015\012";
  chomp($_ = <S>);
  return fail("HELO error ($_)") if /^[45]/ or !$_;
  
  print S "mail from: <$self->{from}>\015\012";
  chomp($_ = <S>);
  return fail("mail From: error ($_)") if /^[45]/ or !$_;

  foreach my $to (@{$self->{to}}) {
    print S "rcpt to: <$to>\015\012";
    chomp($_ = <S>);
    return fail("Error sending to <$to> ($_)\n") if /^[45]/ or !$_;
  }

  # start data part
  print S "data\015\012";
  chomp($_ = <S>);
  return fail("Cannot send data ($_)") if /^[45]/ or !$_;

  # print headers
  foreach my $header (keys %{$self->{header}}) {
    print S "$header: ", $self->{header}->{$header}, "\015\012";
  };

  # send subject
  print S "Subject: $self->{subject}\015\012";

  # send message body
  print S "\015\012", $self->{message}, "\015\012.\015\012";

  chomp($_ = <S>);
  return fail("message transmission failed ($_)") if /^[45]/ or !$_;

  # finish
  print S "quit\015\012";
  $_ = <S>;
  close S;

  return 1;
}

# convert a time() value to a date-time string according to RFC 822
sub _time_to_date {
  my ($self, $time) = @_;
  $time ||= time();

  my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
  my @wdays  = qw(Sun Mon Tue Wed Thu Fri Sat);
  my ($sec, $min, $hour, $mday, $mon, $year, $wday) = (localtime($time));

  my $offset = timegm(localtime) - time;
  my $timezone = sprintf("%+03d%02d", int($offset / 3600), $offset % 3600);

  return sprintf("%s, %d %s %04d %02d:%02d:%02d %s", 
    $wdays[$wday], $mday, $months[$mon], $year+1900, $hour, $min, $sec, $timezone);
}

1;
