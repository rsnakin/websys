package FWork::System::Output;

$VERSION = 1.00;

use strict;

use FWork::System;

sub new { 
  my $class = shift;
  my $config = $system->config;

  my $in = {
    # prefix prepended to all cookie names
    cookies_prefix => true($config->get('cookies_prefix')) ? $config->get('cookies_prefix') : '',
    # path that will be used with all cookies
    cookies_path   => true($config->get('cookies_path')) ? $config->get('cookies_path') : '/',
    # domain that will be used with all cookies
    cookies_domain => true($config->get('cookies_domain')) ? $config->get('cookies_domain') : '',
    # should the cookies be flagged as 'secure'
    cookies_secure => undef, 
    # enable gzip compression?
    gzip           => $config->get('gzip'), 
    @_
  };

  my $self = bless({headers => {}}, $class);

  foreach (qw(cookies_prefix cookies_path cookies_domain cookies_secure)) {
    $self->{$_} = $in->{$_};
  }

  $self->{context} = true($ENV{HTTP_HOST}) ? 'web' : 'shell';

  # enabling gzip compression for the output if gzip parameter was defined
  # and we are in the web context
  $self->gzip(1) if $in->{gzip} and $self->{context} eq 'web';

  # setting p3p policy header if p3p policy is enabled in config
  if ($config->get('p3p_enable')) {
    my $p3p_header;
    $p3p_header .= q( policyref=") . $config->get('p3p_policy_location') . q(") if $config->get('p3p_policy_location');
    $p3p_header .= q( CP=") . $config->get('p3p_compact_policy') . q(");
    $self->header(P3P => $p3p_header) if $p3p_header;
  }

  return $self;
}

sub say {
  my ($self, @content) = @_;
  return if not @content;
  # indicates that something was already sent out with 'say'
  $self->{output} = 1;
  if ($self->{gzip}) {
    $self->{content} .= join('',@content);
  } else {
    $self->_print_header;

    # eval is required to prevent "Connection reset" errors under mod_perl which
    # occur when a client aborts the connection (during print I guess)    
    eval {    
      print @content;
    };
  }
}

sub gzip {
  my ($self, $enable) = @_;

  if ($enable == 1 and not $self->{gzip} and $ENV{HTTP_ACCEPT_ENCODING} =~ /gzip/i) {
    if (eval {require Compress::Zlib}) {
      $self->{gzip} = 1;
      binmode STDOUT;
    } else {
      $self->{gzip} = 0;
    }
  } elsif (true($enable) and $enable == 0) {
    $self->{gzip} = 0;
  }

  return $self->{gzip};
}

sub context { $_[0]->{context} }
sub output  { $_[0]->{output} }

sub _print_header {
  my $self = shift;
  my $in = {
    redirect            => undef,
    permanent_redirect  => undef,
    @_
  };
  
  # use _print_header only if we are in a web environment
  return if $self->context ne 'web';

  if (not $self->{printed}) {
    if ($self->{cookies}) { 
      foreach my $cookie (@{$self->{cookies}}) {
        my $string = "$cookie->{name}=$cookie->{value};";
        $string .= " expires=$cookie->{expires};" if true($cookie->{expires});
        $string .= " path=$cookie->{path};" if true($cookie->{path});
        $string .= " domain=$cookie->{domain};" if true($cookie->{domain});
        $string .= " secure" if $cookie->{secure};
        $self->header('Set-Cookie' => $string);
      }
      delete $self->{cookies};
    }
  
    if ($in->{redirect}) {
      $self->header('Status' => 301) if $in->{permanent_redirect};
      $self->header('Location' => $in->{redirect});
    } else {
      $self->header('Content-Encoding' => 'gzip') if $self->{gzip};
      $self->header('Content-Type' => 'text/html') if false($self->header('Content-Type'));
    }
    
    my $system_id = $system->config->get('system_id');
    $system_id = 'n/a' if false($system_id);
    $self->header('X-FWork-System' => $system_id);
    
    my $headers = '';
    my $status;
    foreach my $name ($self->header) {
      if ($name =~ /^status$/i) {
        $status = {name => $name, value => $self->header($name)};
        next;
      }
      foreach my $value ($self->header($name)) { 
        $headers .= "$name: $value\n" 
      }
    }
    
    # mod_perl 1 or 2
    if ($ENV{MOD_PERL}) {
      my $r; 
      
      # mod_perl 2.0
      if (exists $ENV{MOD_PERL_API_VERSION} && $ENV{MOD_PERL_API_VERSION} == 2) {
        $r = Apache2::RequestUtil->request;
      }
      # mod_perl 1.0
      else {
        $r = Apache->request;
      }
      
      $r->status_line($status->{value}) if $status;
      $r->send_cgi_header("$headers\n");
    } 
    
    # cgi
    else {
      print "$status->{name}: $status->{value}\n" if $status;
      print "$headers\n";
    }

    delete $self->{headers};
    $self->{printed} = 1;
  }
}

sub redirect {
  my ($self, $redirect) = @_;
  my $in = {
    permanent => undef,
    @_
  };
  if (false($redirect)) {
    $redirect = $system->config->get('cgi_url');
  } elsif ($redirect =~ /^\?/) {
    # adding cgi_url before the redirect string if redirect string starts with ?
    $redirect = $system->config->get('cgi_url').$redirect;
  }

  # if redirect doesn't start with http(s) then we add http_host from 
  # environment
  if ($redirect !~ /^http/) {
    $redirect = 'http'.($ENV{HTTPS} ? 's' : '')."://$ENV{HTTP_HOST}".
                ($redirect =~ /^\// ? '' : '/').$redirect;
  }

  $self->_print_header(redirect => $redirect, permanent_redirect => $in->{permanent});
  
  # always stopping the system after a redirect, if you want a different behaviou
  # use _print_header method as it is used above
  $system->stop;
}

sub header {
  my ($self, $key, $value) = (shift, shift, shift);
  my $in = {
    overwrite => undef, # optional, the value will be overwritten if the key already exists
    @_
  };

  # if the key is not defined we return all headers names
  return keys %{$self->{headers}} if false($key);

  if (true($value)) {
    if ($self->{printed} and $self->context eq 'web') {
      die "Can't set headers. Headers already sent out.";
    }
    
    delete $self->{headers}->{$key} if $in->{overwrite};

    # setting the value to the key, value can be a ref to an array
    if (ref $value eq 'ARRAY') {
      push @{$self->{headers}->{$key}}, @$value;
    } else {
      push @{$self->{headers}->{$key}}, $value;
    }
  } 

  return if not $self->{headers}->{$key};

  if (wantarray) {
    return @{$self->{headers}->{$key}};
  } else {
    return $self->{headers}->{$key}->[$#{$self->{headers}->{$key}}];
  }  
}

sub cookie {
  my $self = shift;
  return if not @_;
  
  my $in = {
    name    => undef,
    value   => undef,
    expires => undef,
    path    => undef, # optional
    domain  => undef, # optional
    secure  => undef, # optional
    @_
  };
  
  if ($self->{printed} and $self->context eq 'web') {
    die "Can't set cookies. Headers already sent out.";
  }
  
  push @{$self->{cookies}}, {
    name    => $self->{cookies_prefix} . $in->{name},
    value   => FWork::System::Utils::encode_url($in->{value}),
    expires => $self->_expires($in->{expires}),
    path    => (defined $in->{path} ? $in->{path} : $self->{cookies_path} ? $self->{cookies_path} : undef),
    domain  => (defined $in->{domain} ? $in->{domain} : $self->{cookies_domain} ? $self->{cookies_domain} : undef),
    secure  => (defined $in->{secure} ? $in->{secure} : $self->{cookies_secure} ? $self->{cookies_secure} : undef),
  };
}

sub _expires {
  my ($self, $time) = @_;

  return undef if not $time;

  my @mon = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
  my @wday = qw/Sun Mon Tue Wed Thu Fri Sat/;
 
  my %calculator = (
    s => 1,
    m => 60,
    h => 60*60,
    d => 60*60*24,
    M => 60*60*24*30,
    y => 60*60*24*365
  );

  # format for time can be in any of the forms...
  # "now" -- expire immediately
  # "+180s" -- in 180 seconds
  # "+2m" -- in 2 minutes
  # "+12h" -- in 12 hours
  # "+1d"  -- in 1 day
  # "+3M"  -- in 3 months
  # "+2y"  -- in 2 years
  # "-3m"  -- 3 minutes ago(!)
  # If you don't supply one of these forms, we assume you are
  # specifying the date yourself

  my $offset; my $final;
  if (not defined $time or $time eq "now") {
    $final = time;
  } elsif ($time =~ /^\d+/) {
    $final = $time;
  } elsif ($time =~ /^([+-]?(?:\d+|\d*\.\d*))([mhdMy]?)/) {
    $final = time + (($calculator{$2} || 1) * $1);
  } else {
    $final = $time;
  }

  my $sc = '-';
  # (cookies use '-' as date separator, HTTP uses ' ')

  my ($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($final);
  $year += 1900;

  return sprintf("%s, %02d$sc%s$sc%04d %02d:%02d:%02d GMT",
                 $wday[$wday],$mday,$mon[$mon],$year,$hour,$min,$sec);
}

sub error_404 {
  my $self = shift;

  my $HTML = <<HTML;
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
<head>
<title>404 Not Found</title>
</head>
<body>
<h1>Not Found</h1>
<p>The requested URL $ENV{REQUEST_URI} was not found on this server.</p>
<hr>
<i>FWork System $FWork::System::VERSION</i>
</body>
</html>
HTML

  $self->header('Status' => '404 Not Found');
  $self->say($HTML);

  $system->stop;
}

sub DESTROY { 
  my $self = shift;
  # print out the content buffer that is used when gzip is turned on
  if ($self->{gzip} and true($self->{content})) {
    $self->_print_header;
    # eval is required to prevent "Connection reset" errors under mod_perl which
    # occur when a client aborts the connection (during print I guess)
    eval {
      # binmode is required at least for windows or the gziped data will be
      # damaged, not really required under mod_perl but we still use it
      binmode STDOUT;
      print Compress::Zlib::memGzip($self->{content});
    };
  }  
}

1;

__END__

=head1 NAME

FWork::System::Output - Output mechanism for the FWork System

=head1 SYNOPSIS

  use FWork::System::Output;
  my $out = FWork::System::Output->new;

  use FWork::System::Output;
  my $out = FWork::System::Output->new(
    cookies_prefix => 'stuffed_',
    cookies_path   => '/',
    cookies_domain => '.yourdomain.com'
  );

  # stores a cookie that will be printed out on the first occasion
  $out->cookie(name => 'track_id', value => '20', expires => '+30d');

  # prints 'Hello world!' to the browser, adding automatically 
  # 'Content-type' header if it wasn't already printed out, and all 
  # the additional headers (cookies) that might have been requested
  $out->say('Hello world!');

  # immidiately redirect the user to the specified URL
  $out->redirect('http://www.stuffedguys.com');

=head1 DESCRIPTION

FWork::System::Output is a replacement for a standard CGI.pm module. It shamelessly
borrows some of the techniques and interface designs from CGI.pm.

While CGI.pm provides lots of ways to work with input and output of your Perl
program, FWork::System::Output concentrates exclusively on output and tries to do it 
well and efficiently.

=head1 METHODS

The following methods are currently implemented:

=over 

=item say

Accepts a list of parameters. All of them will be printed to the user's
viewing device (right now we assume that this is a browser). If 'say' method
is called for the first time, all the required (and requested) HTTP headers
will be printed out (this includes optional cookies and the requried content 
type header).

=item cookie

Is used to add one cookie to the header. You can use the following parameters:

'name' is the name of the cookie (optional cookie prefix will be automatically
prepended to it when the cookie header will be sent out);

'value' is the value of the cookie;

'expires' should be used to specify when the cookie should expire. It uses
the standard CGI.pm expires format (+30d - expire in 30 days). If the
expires parameter is not specified, the cookie will expire at the end of
the current session (when the user will close all instances of the current
browser).

=item redirect

Accepts one parameter which should contain the URL. All the required and the
requested headers will be sent out and then the user will be redirected to
the specified URL (via use of 'Location:').

=back

=head1 TODO

* A separate method for sending out files is required. It should automatically
try to determine the type of the file, its size, put STDOUT into 'binmode' and
finally print the file out. It should also be able to open and close the file.
Probably we could use some module from CPAN?

* A chunked gzip should be implemented as it is a much more efficient method
of sending output. We will not be storing every 'say' in a buffer and send it
all at the end. Instead, it will be possible to send chunks of gzipped output
to the user, which should decrease the system response time dramatically.

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=head1 SEE ALSO

L<FWork::System::Input>, L<CGI>.

=cut