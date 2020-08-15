package FWork::System::Language;

$VERSION = 1.00;

use strict;

use FWork::System::True;

sub new {
  my $class = shift;
  my $in = {
    id  => undef, # language id
    pkg => undef, # pkg object
    @_
  };
  return if not ref $in->{pkg} or false($in->{id});
  my $path = $in->{pkg}->_path;

  my $self = bless({pkg => $in->{pkg}}, $class);

  # downgrading language to default
  if (not -d "$path/languages/$in->{id}" and $in->{id} ne 'default') {
    $in->{id} = 'default';
  }

  if (-d "$path/languages/$in->{id}") {
    $self->{id} = $in->{id};
    $self->{path} = "$path/languages/$self->{id}";
    $self->{config} = FWork::System::Config->new("$path/languages/$self->{id}.cgi");
  }

  return $self;
}

sub load {
  # file specified a filename to load relative to the language directory
  my ($self, $file) = @_;
  return FWork::System::Language::Text->new($self, $file);
}

sub exists { true($_[0]->{id}) }
sub id     { $_[0]->{id}   }
sub path   { $_[0]->{path}   }
sub config { $_[0]->{config} }

# ============================================================================

package FWork::System::Language::Text;

use vars qw($VERSION);
use FWork::System;

$VERSION = 1.00;

sub new {
  my ($class, $language, $file) = @_;
  return undef if false($file);

  my $self = bless({language => $language, file => $file}, $class);

  my $filename = "$language->{path}/$file";

  if (not -r $filename) {
    $self->{content} = {};
    return $self;
  }

  # we are copying values from the cache instead of directly assigning them
  # we think this is safer (see also FWork::System::Config)
  my $cache = $system->stash('__language_cache') || {};
  if ($cache->{$filename}) {
    $self->{content} = {%{$cache->{$filename}}};
    return $self;
  }

  my $cache = $system->stash('__language_cache');

  {
    no strict 'vars';
    local $text = {};
    my $f = FWork::System::File->new($filename, 'r');
    eval($f->contents); die $@ if $@;
    $f->close;
    $cache->{$filename} = $text;
    $self->{content} = {%$text};
  }

  $system->stash(__language_cache => $cache);

  return $self;
}

sub get {
  my ($self, $key, @params) = @_;
  
  # if the key doesn't exist in the current file, we try to load the same 
  # file from the default language (if the current language exists and it is 
  # not default already) and take the key from there (this is a fallback 
  # procedure).
  if (
    false($self->{content}->{$key}) and 
    $self->{language}->exists and 
    $self->{language}->id ne 'default') 
  {
    # creating a default language object if we haven't done it already
    $self->{language}->{_default_language} = FWork::System::Language->new(
      id  => 'default',
      pkg => $self->{language}->{pkg},
    ) if not $self->{language}->{_default_language};

    # loading current file for the default language if we haven't done so
    if (not $self->{_default_file}) {
      $self->{_default_file} = $self->{language}->{_default_language}->load($self->{file});
    }
    
    return $self->{_default_file}->get($key, @params);
  } else {
    return (@params ? sprintf($self->{content}->{$key}, @params) : $self->{content}->{$key});
  }
}

1;