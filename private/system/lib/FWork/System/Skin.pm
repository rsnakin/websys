package FWork::System::Skin;

$VERSION = 1.00;

use strict;
use vars qw($AUTOLOAD);

use FWork::System::True;

sub new {
  my $this = shift;
  my $in = {
    id  => undef, # id of the skin
    pkg => undef, # pkg object
    @_
  };
  return if not ref $in->{pkg} or false($in->{id});
  my $self = bless($in, $this);

  my $pkg = $in->{pkg};

  # downgrading the skin to Default if the requested is not found
  if ($self->{id} ne 'default' and 
      (not -d $pkg->_path."/skins/$self->{id}" or
       not -r $pkg->_path."/skins/$self->{id}.cgi"))
  {
    $self->{id} = 'default';
  }

  $self->{path} = $pkg->_path."/skins/$self->{id}";

  $self->{config} = FWork::System::Config->new($pkg->_path."/skins/$self->{id}.cgi");
  $self->{config}->set(public_path => $pkg->_public_path . "/skins/$self->{id}");
  $self->{config}->set(public_url => $pkg->_public_url . "/skins/$self->{id}");

  my $languages = $self->{config}->get('supported_languages');
  if ($languages and ref $languages eq 'ARRAY') {
    my $found;
    foreach (@$languages) {
      $found = 1 if $_ eq $pkg->_language->id;
    }
    $self->{config}->set(language => ($found ? $pkg->_language->id : $languages->[0]));
  }
    
  return $self;
}

sub AUTOLOAD { 
  my $self = shift;
  my ($method) = $AUTOLOAD =~ /([^:]+)$/;
  eval "sub $method { \$_[0]->{$method} } 1;" || die $@;
  return $self->$method(@_);
}

sub DESTROY {}

1;

__END__

=head1 NAME

FWork::System::Skin - Skins framework for the FWork System

=head1 LANGUAGES

Skins framework supports internationalization, you can create sets of graphics
for different languages and some other things. If you want to support this
feature in your skin you will need to define 'supported_languages' option in
the skin configuration file like this:

  $config->{supported_languages} = ['english', 'russian'];

The first language in the array is the default one. If the currently 
selected language (for the package) will not be supported by your skin, then
the default one will be used.

In order to access the language selected for this skin you can use a special
skin property in your skin templates:

  <% $skin.language %>

You can do different things with it:

<img src="<% $skin.public_url %>/images/<% $skin.language %>/edit.gif">

or

<%if $skin.language = "english"%>
  English content here
<%/if%>

<%if $skin.language = "russian"%>
  Russian content here
<%/if%>

=cut