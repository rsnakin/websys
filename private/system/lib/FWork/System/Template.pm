package FWork::System::Template;

$VERSION = '1.22';

# History:
# 1.22 -- added stripping html comments before compiling
# 1.21 -- significant optimization, templates with large vars data could be
#         up to 10-15 times faster now; instead of adding each new block to a
#         string $p, we now push them in an array @p and then just do 
#         join('', @p) in the end.
# 1.20 -- include block now supports flags.
# 1.19 -- correctly handling empty templates now.

use strict;
use vars qw($AUTOLOAD);
use FWork::System;

my $tag_start = '<(?:%|\?=?)';
my $tag_end = '(?:%|\?)>';

sub new {
  my $self = bless({}, shift);
  my $in = {
    pkg         => undef, # pkg object
    file        => undef, # template can be initialized either from a file
    template    => undef, # or from a plain piece of template
    text        => undef, 
    tmplname    => undef, # name of the template file (if using a text template)
    tag_start   => undef,
    tag_end     => undef,
    cache       => undef, # optional, 'always', '60s', '1m', '1h', '1d', '1M', etc
    skin_id     => undef, # optional, will be used to override the skin object 
                          # contained in the supplied package object
    language_id => undef, # optional, will be used to override the language 
                          # object contained in the supplied package object
    flags       => undef, # optional, ARRAY ref of flags that should be accessible in the current template
    @_
  };
  return if not ref $in->{pkg};

  $self->{pkg} = $in->{pkg};

  if (true($in->{skin_id})) {
    require FWork::System::Skin;
    $self->{skin} = FWork::System::Skin->new(
      id  => $in->{skin_id},
      pkg => $in->{pkg},
    );
  } else {
    $self->{skin} = $self->{pkg}->_skin;
  }

  if (true($in->{language_id})) {
    require FWork::System::Language;
    $self->{language} = FWork::System::Language->new(
      id  => $in->{language_id},
      pkg => $in->{pkg},
    );
  } else {
    $self->{language} = $self->{pkg}->_language;
  }
  
  if (ref $in->{flags} eq 'ARRAY') {
    foreach my $flag_name (@{$in->{flags}}) {
      $self->{flags}->{$flag_name} = 1;
    }
  }

  $self->{tag_start} = defined $in->{tag_start} ? $in->{tag_start} : $tag_start;
  $self->{tag_end} = defined $in->{tag_end} ? $in->{tag_end} : $tag_end;
  $self->{cache_enabled} = $in->{cache};
 
  if (true($in->{file})) {
    # we treat a file with a physical path as a plain text file, we also
    # consider the root in this case to be document root of this web site,
    # this is done to mimic SSI behaviour
    if ($in->{file} =~ /^(?:[\/\\]|\w:)/) {
    	my $filename = $ENV{DOCUMENT_ROOT}.$in->{file};
      my $f = FWork::System::File->new($filename, 'r') || die "Can't open plain file $in->{file}: $!";
      $self->{plain} = $f->contents;
      $f->close;
    } else {
      my $filename = $self->{skin}->path."/$in->{file}";

      # full path to the template (usually physical)
      $self->{file} = $filename;
      # short path to the template (usually relative)
      $self->{tmplname} = $in->{file};

      if ($self->{cache_enabled}) {
        my ($cache_file, $valid) = $self->check_cached($filename, $self->{cache_enabled});
        $self->{cache_file} = $cache_file;
        if ($valid) {
          my $f = FWork::System::File->new($cache_file, 'r') || die "Can't open cached template $cache_file: $!";
          $self->{parsed} = $f->contents;
          $f->close;
          $self->{tmpl_cached} = 1;
          return $self;
        }
      }
      
      $self->{text} = $in->{text} || $self->{language}->load("$in->{file}.cgi");
      
      if (not -r $filename) {
        die "Template '$filename' doesn't exist or can't be opened for reading!";
      }

      my ($cgifile, $exists) = $self->check_compiled($filename);

      if ($exists) {
        no strict 'vars';
        local $compiled = {};
        
        # this part was intentionally done without a usual Perl's "require",
        # because under mod_perl a process could start reading a compiled template
        # before it was actually written completely by another process; this
        # resulted in Perl compile errors; our File class uses locks when 
        # opening files, so such problem never happens with it.
        my $tmpl = FWork::System::File->new($cgifile, 'r') || die "Can't open compiled template $cgifile for reading: $!";
        my $code = $tmpl->contents;
        $tmpl->close;
        eval $code || die "Fatal error encountered while evaling template \"$cgifile\":\n$@\n";
        
        $self->{compiled} = $compiled;

        # checking version of FWork::System::Template that was used to compile the
        # template, if it is not equal to the current FWork::System::Template version
        # we recompile the template
        $exists = undef if $compiled->{version} != $FWork::System::Template::VERSION;
        
        # checking if strip_html_comments config option was the same when the 
        # template was compiled as it is now, if it is not so we force template
        # recompilation
        $exists = undef if $compiled->{strip_html_comments} ne $system->config->get('strip_html_comments');
      }

      if (not $exists) {
        my $f = FWork::System::File->new($filename, 'r') || die "Can't open template $filename: $!";
        $self->{template} = $f->contents;
        $f->close;

				# stripping html comments if necessary
				require FWork::System::Utils;
				my $stripped_html = FWork::System::Utils::strip_html_comments(
					html			=> $self->{template},
					filename	=> $filename,
				);
				$self->{template} = $stripped_html if true($stripped_html);
												
        my $code = $self->_finalize_compiled($self->compile);

        my $f = FWork::System::File->new($cgifile, 'w') || die "Can't write compiled template '$cgifile'. $!";
        $f->print($code)->close;

        no strict 'vars';
        local $compiled = {};      
        eval $code || die "Fatal error encountered while compiling template \"$self->{tmplname}\":\n$@\n";
        $self->{compiled} = $compiled;
      }
    }
  } elsif (true($in->{template})) {
    $self->{template} = $in->{template};
    $self->{text} = $in->{text} if $in->{text};
    $self->{tmplname} = defined $in->{tmplname} ? $in->{tmplname} : 'unknown';

    my $code = $self->_finalize_compiled($self->compile);

    no strict 'vars';
    local $compiled = {};      
    eval $code || die "Fatal error encountered while compiling template \"$self->{tmplname}\":\n$@\n";
    $self->{compiled} = $compiled;
  } else {
    return $self;
  }

  return $self;
}

sub _finalize_compiled {
  my $self = shift;
  my $code = shift;
#  return '' if false($code);

  my $top = '';
  if (ref $self->{compiled_top} eq 'HASH') {
    $top = join('', keys %{$self->{compiled_top}})."\n";
  }

  my $strip_html_comments = $system->config->get('strip_html_comments');

  my $time = localtime();
  my $code = <<CODE;
# Generated: $time
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; \$compiled->{version} = '$FWork::System::Template::VERSION'; \$compiled->{strip_html_comments} = '$strip_html_comments'; \$compiled->{code} = sub {
my \$s=shift \@_; my \$v=\$s->{vars}; my \@p=(); my \$in = \$system->in;
$top$code
\$s->{parsed}=join('',\@p);
};
1;
CODE
  
  return $code;
}

sub parse { 
  # vars should be passed as a ref to 'HASH'
  my ($self, $vars) = @_;

  # we return plain text if plain text was loaded (property exists)
  if (exists $self->{plain}) {
    return (true($self->{plain}) ? $self->{plain} : '');
  }

  if ($self->{tmpl_cached}) {
    return (true($self->{parsed}) ? $self->{parsed} : '');
  }

  $self->{vars} = ref $vars eq 'HASH' ? $vars : {};

  if (not $self->{compiled}->{code}) {
    die "Template '$self->{tmplname}' was not properly compiled, can't execute."
  }

  # specifying the name of the top template in the stash
  if (false($system->stash('__top_template'))) { 
    $system->stash(__top_template => $self->{tmplname});
  } 

  # executing compiled template
  $self->{compiled}->{code}->($self);

  if ($self->{cache_enabled}) {
    my $f = FWork::System::File->new($self->{cache_file}, 'w') || die "Can't write cached templated '$self->{cache_file}'. $!";
    $f->print($self->{parsed})->close;    
  }

  return (true($self->{parsed}) ? $self->{parsed} : '');
}

sub check_cached {
  my ($self, $file, $cache) = @_;
  return if false($file) or false($cache);

  my ($path, $filename) = $file =~ /^(.+?)([^\\\/]+)$/;
  $path .= '_cache';

  if (not -d $path) {
    mkdir($path, 0777) || die "Can't create directory [ $path ] for cached templates: $!\n";
  }
  my $cache_file = "$path/$filename.cgi";
  return ($cache_file, undef) if not -e $cache_file;

# always rebuild
#return $cache_file, 0;

  my $cached_modtime = (stat($cache_file))[9];
  my $tmpl_modtime = (stat($file))[9];

  my $rebuild = $tmpl_modtime > $cached_modtime;
  return $cache_file, 0 if $rebuild;

  if ($cache ne 'always') {
    my %calculator = (
      s => 1,
      m => 60,
      h => 60*60,
      d => 60*60*24,
      M => 60*60*24*30,
      y => 60*60*24*365
    );    

    my ($num, $type) = $cache =~ /^(\d+)(\D+)$/;
    return $cache_file, 0 if not defined $num or not defined $type;

    my $secs = $num*$calculator{$type};
    
    return $cache_file, $cached_modtime >= time-$secs;
  }

  # do not rebuild, if we've got so far
  return $cache_file, 1;
}

# checking if the compiled template file should be recompiled or used as is
sub check_compiled {
  my ($self, $file) = @_;
  return if false($file);

  my ($path, $filename) = $file =~ /^(.+?)([^\\\/]+)$/;
  $path .= '_compiled';

  if (not -d $path) {
    mkdir($path, 0777) || die "Can't create directory [ $path ] for compiled templates: $!\n";
  }
  my $cgi_file = "$path/$filename.cgi";
  return ($cgi_file, undef) if not -e $cgi_file;

# recompile if so was requested in parameters
  return $cgi_file, 0 if $system->in->query('__recompile_template');

  my $cgi_modtime = (stat($cgi_file))[9];
  my $tmpl_modtime = (stat($file))[9];

  return $cgi_file, $cgi_modtime >= $tmpl_modtime;
}

sub cached { $_[0]->{tmpl_cached} }

sub AUTOLOAD {
  require FWork::System::Template::Parser if not defined &FWork::System::Template::compile;
  die "Can't locate function [ $AUTOLOAD ]" if not defined &$AUTOLOAD;
  no strict 'refs'; return &{"$AUTOLOAD"}(@_);
}

sub DESTROY {}

1;

__END__

=head1 NAME

FWork::System::Template - Templates framework for the FWork System

=head1 SYNOPSIS

  use FWork::System::Template;

  # creating new template object from the template 'f.html'
  my $t = FWork::System::Template->new(file => 'f.html', pkg => $st_pkg_obj);

  # parsing template with variables specified in $vars_hash
  my $parsed = $t->parse($vars_hash);

=head1 DESCRIPTION

There are three main concepts used in the FWork Template framework: blocks,
complex variables and (variable) modifiers.

When the template is first parsed, it is being complied into Perl code and 
stored in the F<_compiled/filename.cgi> file. Next time the template is parsed,
we check if the original template was modified. If it was modified, we 
recompile it, if it remained intact we just load the compiled template, thus
saving a significant amount of CPU. 

If the version of the FWork::System::Template class doesn't match the version that
was used to compile the template, we initiaite the recompilation process as
well.

=head1 PARSING

If the block is not single and the starting tag or the ending tag of the 
block is alone on a line then our parsing mechanism removes one new line
from the parsed result, in other words the line where the tag is located
is effectively removed.

This makes sense in most cases and allows us to produce more consistent
parsing results (without extra new lines).

=head1 RESERVED VARIABLES

This information is intended for the new FWork Template handlers authors. 
Authors can use the variables listed below when creating Perl code in their 
handlers. Also, the variables below are considered internal in the compiled
templates, so they can't be used for anything else or redefined.

$s = $self - this is a template object

$v = $self->{vars} - this is a variables hash that is given to the template
                      when parsing.

$p = $self->{parsed} - this is where we collect parsed data.

=head1 NOTES

Templates should only be loaded from the FWork System framework. Everytime 
when a new template is initialized, you should specify its filename relative 
to the skin directory and a package object, to which the template belongs to. 
If you will specify a physical path to the template file then it will be 
opened in a special I<plain mode>, when B<no compiling or parsing is done> at 
all and the contents of the file are returned as is.

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=cut