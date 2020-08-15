package FWork::System::Package;

$VERSION = 1.00;

use strict;
use vars qw($AUTOLOAD);

use FWork::System;

sub _new {
  my ($class) = shift @_;

  my $self = bless({}, $class);

  (my $pkg = $class) =~ s/FWork::System::Package:://g;
  $pkg =~ s/::/:/g;

  # checking that we haven't already started initialization of the specified
  # package, this is required for protection from a potential recursion
  if ($system->stash('_system_pkg_init'.$pkg)) {
    die "Recursion detected during package '$pkg' initialization!";
  }
  
  $system->stash('_system_pkg_init'.$pkg => 1);

  my $pkg_path = $class->_create_path($pkg);

  # calculating physical path to this package, first using the 
  # globally defined system path
  my $path = $system->path . "/private/$pkg_path";
  # then using the globally defined packages path
  if (not -d $path) {
    $path = $system->path('pkg') . "/private/$pkg_path";
    if (not -d $path) {

      # we only die if 404 error was not requested in system config
      if (not $system->config->get('use_404')) {
        die "Package [ $pkg ] is not supported!\n" ;
      } 

      # if 404 URL was specified we redirect there
      elsif (true($system->config->get('error_404_URL'))) {
        $system->out->redirect($system->config->get('error_404_URL'));
        $system->stop;
      }

      # or we just print out a standard 404 error message and headers
      else {
        $system->out->error_404;
      }
    }
  } 

  # system package lib is already in @INC
  $class->_add_to_inc($pkg);
 
  $self->{_path} = $path;
  $self->{_name} = $pkg;
 
  # parent package
  my ($parent) = $pkg =~ /^(.+?):[^:]+$/;
  $self->{_parent} = $system->pkg($parent) if true($parent);

  # loading config if it exists
  $self->{_config} = FWork::System::Config->new("$path/config/config.cgi");

  my $public_path = $self->{_config}->get('public_path');
  if (false($public_path) and $self->{_parent}) {
    $public_path = $self->{_parent}->_config->get('public_path');
  }
  if (false($public_path)) {
    $public_path = $system->config->get('public_path');
    $public_path = $system->path if false($public_path);
  }
  $self->{_public_path} = "$public_path/$pkg_path";

  my $public_url = $self->{_config}->get('public_url');
  if (false($public_url) and $self->{_parent}) {
    $public_url = $self->{_parent}->_config->get('public_url');
  }
  $public_url = $system->config->get('public_url') if false($public_url);
  $self->{_public_url} = "$public_url/$pkg_path";

  $self->_init;

  # removing init marker for this package
  $system->stash('_system_pkg_init'.$pkg => undef);

  # saving package in the the FWork System packages container
  $system->_save_pkg($self);

  # processing 'startup' event
  $self->_event('startup')->process(pkg => $self);

  return $self;
}

sub _template {
  my $self = shift;
  my $file = shift;
  
  # if the template file was not specified we are using a default name (caller 
  # sub name + '.html'
  if (false($file)) {
    my ($sub) = (caller(1))[3] =~ /::([^:]+)$/;;
    $file = $sub.'.html';
  }

  require FWork::System::Template;
  return FWork::System::Template->new(file => $file, pkg => $self, @_);
}

sub _skin {
  my $self = shift;

  return $self->{_skin} if $self->{_skin};

  # initializing skin
  my $skin_id = $self->{_config}->get('skin_id');
  $skin_id ||= $self->{_parent}->_skin->id if $self->{_parent};
  $skin_id ||= 'default'; # dafault skin if everything else fails

  require FWork::System::Skin;
  $self->{_skin} = FWork::System::Skin->new(id => $skin_id, pkg => $self);

  return $self->{_skin};
}

sub _language {
  my $self = shift;

  return $self->{_language} if $self->{_language};

  # initializing language
  my $language_id = $self->{_config}->get('language_id');
  $language_id ||= $self->{_parent}->_language->id if $self->{_parent};
  $language_id ||= $system->config->get('language_id');
  $language_id ||= 'default'; # default language if everything else fails

  require FWork::System::Language;
  $self->{_language} = FWork::System::Language->new(
    id  => $language_id, 
    pkg => $self,
  );

  return $self->{_language};
}

sub _init {
  my $self = shift;
  my $class = ref $self;
  if (not defined &{$class.'::_init'}) {
    my $file = "$self->{_path}/config/_init.cgi";
    if (-r $file) {
      # if _init file exists for the current package we compile it
      eval "package $class; require '$file'; 1;" || die $@;
    } else {
      # if the file doesn't exist we create an empty sub _init instead
      eval "package $class; sub _init {}; 1;" || die $@;
    }
  }
  $self->_init;
}

sub _check_privs {
  my $self = shift;
  my $class = ref $self;
  if (not defined &{$class.'::_check_privs'}) {
    my $file = "$self->{_path}/config/_check_privs.cgi";
    if (-r $file) {
      # if _check_privs file exists for the current package we compile it
      eval "package $class; require '$file'; 1;" || die $@;
    } else {
      # if the file doesn't exist we create empty sub _check_privs instead
      eval "package $class; sub _check_privs {}; 1;" || die $@;
    }
  }
  $self->_check_privs;
}

sub _properties {
  my ($self, $key) = @_;
  return if false($key);
  my $file = "$self->{_path}/config/properties.cgi";
  if (not $self->{_properties} and -r $file) {
    require FWork::System::File;
    no strict 'vars';
    local $properties = {};
    eval(FWork::System::File->new($file, 'r')->contents); die $@ if $@;
    $self->{_properties} = $properties;
  } elsif (not $self->{_properties}) {
    $self->{_properties} = {};
  }
  return $self->{_properties}->{$key};
}

sub _run {
  my $self = shift;
  my $action = $system->in->query('action');
  if (true($action) and $action =~ /^_/) {
    die q(Name of the action can not start with the underscore "_"!);
  }
  # default action in all packages should be called 'index'
  $action = 'index' if false($action);
  $self->$action();
}

sub _event {
  my ($self, $event) = @_;
  return if false($event);
  if (not $self->{_events}->{$event}) {
    require FWork::System::Event;
    $self->{_events}->{$event} = FWork::System::Event->new(name => $event, pkg => $self);
  }
  return $self->{_events}->{$event};
}

sub _error {
  my ($self, $entry, @params) = @_;
  my $errors = $self->_language->load('_system/errors.cgi');
  my $string = $errors->get($entry, @params);
  return (true($string) ? $string : $entry);
}

sub _add_to_inc {
  my ($class, $pkg) = @_; 
  return if false($pkg);

  my $path = $system->path.'/private/'.$class->_create_path($pkg);
  my %inc_idx = map {$_ => 1} @INC; 
  return if $inc_idx{"$path/lib"};
  
  unshift @INC, "$path/lib" if -d "$path/lib";
}

sub _create_path { join('/packages/', split(/:/, $_[1])) }

sub _get_user {
  my $class = shift;
  my $in = {
    id  => undef,
    pkg => undef,
    @_
  };
  my $id = $in->{id};
  my $pkg = $in->{pkg};
  return undef if not $id or false($pkg);

  my $user;

  my $pkg_path = $system->path.'/private/'.$class->_create_path($pkg);
  my $filename = "$pkg_path/config/get_user.cfg";
  if (-r $filename) {
    my $file = FWork::System::File->new($filename, 'r');
    if ($file) {
      my $package = $file->line;
      $package =~ s/^\s+//; $package =~ s/\s+$//;
      my $function = $file->line;
      $function =~ s/^\s+//; $function =~ s/\s+$//;
      $file->close;
      if (true($package) and true($function)) {
        $class->_add_to_inc($pkg);
        eval "require $package" || die $@;
        # if user was not found, we assign $user to 0, indicating that we've
        # checked, but have found nothing
        no strict 'refs';
        $user = &{$package.'::'.$function}(id => $id) || 0;
      }
    }
  } 

  return $user;
}


sub AUTOLOAD { 
  my $self = shift;

  my $error = sub {  
    # we only die if 404 error was not requested in system config
    if (not $system->config->get('use_404')) {
      die qq(Action "$_[0]" is not supported in package "$self->{_name}"!\n)
    } 

    # if 404 URL was specified we redirect there
    elsif (true($system->config->get('error_404_URL'))) {
      $system->out->redirect($system->config->get('error_404_URL'));
      $system->stop;
    }

    # or we just print out a standard 404 error message and headers
    else {
      $system->out->error_404;
    } 
  };

  # getting current package name from the current object
  my $class = ref $self;

  if (not $class or $class !~ /FWork::System::Package/) {
    die qq(Function or method "$AUTOLOAD" is not supported!\n);
  }

  # removing potentially dangerous characters
  $AUTOLOAD =~ s/[\\\/]|\.\./_/g;

  my ($method) = $AUTOLOAD =~ /([^:]+)$/;

  if ($method =~ /^_/) {
    eval "sub $method { \$_[0]->{$method} } 1;" || die $@;
    return $self->$method();
  }

  if (not -e "$self->{_path}/$method.cgi") {
    my $tmpl_file = $self->_skin->path."/$method.html";
    if (-e $tmpl_file) {
      $self->_check_privs;
      my $template = $self->_template("$method.html");
      $system->out->say($template->parse($self->{vars}));
      $system->stop;
    } else {
      $error->($method);
    }
  }

  eval qq(package $class; require "$self->{_path}/$method.cgi"); die $@ if $@;
  $error->($method) if not defined &{$AUTOLOAD};
  $self->_check_privs;
  $self->$method(@_);
}

sub DESTROY {}

1;

__END__

=head1 NAME

FWork::System::Package - Base class for all packages in the system

=head1 DESCRIPTION

This class is inherited by all packages in the system. We generate a separate
class for every package using this rule:

  C<FWork::System::Package::top_package::sub_package::another_subpackage>

This is required to separate each package's namespace so that they don't 
collide.

=head1 LOGIC

=head2 Choosing action

1. If action was specified for the package (as '&action' parameter) then 
we try to load this action.

2. We also check if the specified action name starts with the underscore (_).
If it is, then we finish with an error, because public actions can not start
with the underscore. Functions with the underscore as the first character of
their name are reserved for internal use in the FWork::System::Package class
and its children.

3. Finally, if the action was not specified, we try to load 'index' action
that should always be present in every package. You can easily make 'index'
action to call the action that you want to be the real default action in
the package. Actually, 'index' action is just a neat way to define a default
action for every package.

=head2 Choosing language

When we choose a language for the package that is being loaded we go trough 
the following steps:

1. First we check for the language setting in the user preferencies for the
   package that we are loading.

2. If language is still undefined, we check if the language parameter is
   specified in the configuration file for the package that we are loading.

3. If language is still undefined, we check if the package that we are loading
   has a parent and if this is true, we get the language from the parent. All
   sub-packages will usually stop at this point, because parent package will
   always have a language defined.

4. If language is still undefined, we check for the language setting in the
   user preferencies for the 'system' package.

5. If language is still undefined, we check if the language parameter is 
   specified in the configuration file for the 'system' package.

6. If all this fails, we assign the default language as the language for
   the package that we are loading. Currently default language is always
   'English'.

Than being said, normally we would expect to load language definition either
from user's settings for the 'system' package or from the configuration of
the 'system' package. But there are a lot of other possibilities that we
support as well.

=head1 LIMITATIONS

Since we are generating separate classes for every package, package names
should meet Perl requirements for its package names. Basically, you will be
safe if you will use only letters, digits or underscore ([0-9a-zA-Z_]).

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=head1 SEE ALSO

L<FWork::System>.

=cut