package FWork::System::Config;
#use utf8;
$VERSION = 1.00;

use strict;

use FWork::System::True;
use FWork::System::File;

sub new {
  my ($class, $file) = @_;
  return if false($file);
  my $self = bless({file => $file}, $class);

  return $self->reload;
}

sub reload {
  my $self = shift;
  my $file = $self->{file};
  
  if (not $file or not -f $file) {
    $self->{options} = {};
    return $self;
  }
  
  {
    no strict 'vars';
    local $config = {};
    eval(FWork::System::File->new($file, 'r')->contents); die $@ if $@;
    $self->{options} = $config;
  }
  
  return $self;
}

sub get_all {
  my $self = shift;
  return $self->{options};
}

sub get { 
  my ($self, $key) = @_;
  return keys %{$self->{options}} if false($key);
  return $self->{options}->{$key};
}

sub set {
  my ($self, @pairs) = @_;
  return if not @pairs;
  while (@pairs) {
    my ($key, $value) = splice(@pairs, 0, 2);
    $self->{options}->{$key} = $value;
  }
  return $self;
}

sub save {
  my ($self, $data, $in) = (shift, shift, {overwrite => undef, @_});
  return if false($self->{file});

  # if $data is not specified we just write all parameters from the
  # current config object in a file
  $data ||= {};

  (my $dir = $self->{file}) =~ s/[\/\\][^\/\\]+$//;
  FWork::System::Utils::create_dirs($dir) if not -d $dir;
  
  my $config = FWork::System::File->new($self->{file}, 'w', {access => 0666}) || die "Can't open file $self->{file} for writing: $!";

  # removing all parameters from this config object if "overwrite" param
  # was specified
  $self->{options} = {} if $in->{overwrite};

  # adding all keys from $data to the current config object, if
  # some keys already exist in current config object then they are
  # overwritten with new values
  foreach my $key (keys %$data) {
    $self->{options}->{$key} = $data->{$key};
  }

  my @lines;
  foreach my $key (sort keys %{$self->{options}}) {
    $key = FWork::System::Utils::quote($key) if $key =~ /\W/;
    push @lines, "\$config->{$key} = ".FWork::System::Utils::produce_code($self->{options}->{$key}, spaces => 1).';';
  }

  $config->print(join("\n", @lines)."\n\n1;");
  $config->close;  
}

1;

__END__

=head1 NAME

FWork::System::Config - Configuration reading and writing class

=head1 SYNOPSIS

  use FWork::System::Config;
  
  # loading config file if it exists, doing nothing if doesn't (no errors)
  my $config = FWork::System::Config->new('file/with/full/path');

  # retrieve configutation parameter
  $config->get('some_key');

  # set configuration parameter
  $config->set(some_key => 'some_value');

  # write new data to the file, overwriting the old file, but saving
  # any options that were present in the config, but are not specified
  # to the save method; to override this behaviour and overwrite the old
  # file completely an additional parameter for overwriting should be 
  # specified
  $config->save({
    some_key    => 'some_value', 
    another_key => 'another_value',
  }, overwrite => 1 # optional parameter, asks for overwriting
  );

  # this will also work correctly - save method understands plain parameters
  # as well as references to HASHes or ARRAYs and it can produce a correct
  # Perl structure of unlimited depth when saving this information
  $config->save({
    some_key => {hash_key => ['1', '2']}
  });

=head1 DESCRIPTION

FWork::System::Config is an abstraction class for configuration files, 
specially designed to be used as a part of the FWork System.

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=cut