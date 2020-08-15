package FWork::System::Sub;

$VERSION = 1.00;

use strict;

use FWork::System;

sub new { 
  my $class = shift;
  my $in = {
    name => undef, # name of the sub to initialize
    pkg  => undef, # current package object
    vars => undef, # template variables
    @_
  };
  return if false($in->{name}) or false($in->{pkg});
  (my $pkg = $in->{pkg}->_name) =~ s/:/::/g;
  $pkg = 'FWork::System::Sub::'.$pkg;
  my $sub = $pkg.'::'.$in->{name};
  my $subs_path = $in->{pkg}->_path.'/subs';
  if (not defined &{$sub}) {
    my $error = sub {die "Sub \"$in->{name}\" is not supported in package \"".$in->{pkg}->_name."\"!\n"};
    $error->($in->{name}) if not -e $in->{pkg}->_path."/subs/$in->{name}.cgi";
    eval qq(package $pkg; use FWork::System; ) .
         qq(require "$subs_path/$in->{name}.cgi") || die $@;
    $error->($in->{name}) if not defined &{$sub};
  }
  return bless({name => $sub, path => $subs_path, vars => $in->{vars}}, $class);
}

sub execute {
  my ($self, $query) = @_;
  return if $self->false($self->{name});
  if (true($query)) {
    while ($query =~ /([^=\s]+)="([^"]*?)"/g) {
      $self->add_query($1, $2);
    }
  }
  no strict 'refs';
  return &{$self->{name}}($self);
}

sub add_query {
  my ($self, $key, $value) = @_;
  return undef if false($self->{name}) or false($key) or false($value);
  push @{$self->{query}->{$key}}, $value;
}

sub get_query {
  my ($self, $key) = @_;
  return undef if false($self->{name});
  return ($self->{query} ? [keys %{$self->{query}}] : undef) if false($key);
  return undef if false($self->{query}->{$key});
  return wantarray ? @{$self->{query}->{$key}} : $self->{query}->{$key}->[0];
}

sub delete_query {
  my ($self, $key) = @_;
  return if false($self->{name}) or false($key);
  delete $self->{query}->{$key};
}

sub DESTROY {}

1;

__END__

=head1 NAME

FWork::System::Sub - Generates and imports variables in the templates during 
templates parsing (execution).

=head1 SYNOPSIS

  use FWork::System::Sub;
  my $sub = FWork::System::Sub->new(name => $sub_name, pkg => $pkg_object);
  $sub->add_query(this => 'is that');
  $sub->execute;

  # import results of running sub 'timezones' in the current template 
  # insert the returned 'zone' variable in the current position in the
  # current template
  <% import timezones %>
  <% $timezones.zone %>

=head1 DESCRIPTION

Subs are separate files with a single sub inside. The name of the sub should 
be equal to the name of the file. Subs files should be located in F<subs> 
directory inside a particular F<package> directory.

Subs should return an anonymous hash, each key of the hash is a variable
that can be accessed from a template with a special construct.

  <% import timezones %>
  <% $timezones.zone %>

By default, variables generated by the sub are imported in the current 
template under the C<sub_name> namespace. Sub 'timezones' created a 
'timezones' namespace in the example above. However, this behaviour can 
be easily overriden.

Example:

    <% import timezones as zones %>
    <% $zones.zone %>

This can be useful when you import the same sub several times in the same
template and you don't want the variables that are created by the sub to
overwrite each other. You might also have a variable with the same name
in the template and you might decide not to overwrite it.

It is possible to call a sub from another package.

Example:

    <% import timezones from system as zones %>
    <% $zones.zone %>

You can also pass parameters to subs.

Example:

    <% import timezones offset="+8" %>
    <% $timezones.zone %>

There can be an unlimited number of parameters. Parameters can have the same 
name, in this case you will be able to access all of them inside the sub by 
running a loop:

    foreach ($self->get_query('offset')) {
      # do something here
    }

The same C<get_query> method is used when you want to access only one
parameter inside the sub's code.

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=head1 SEE ALSO

L<FWork::System::Template>.

=cut