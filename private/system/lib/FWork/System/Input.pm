package FWork::System::Input;

$VERSION = 1.00;

use strict;

use FWork::System;
use FWork::System::Utils qw(&decode_url &create_random);

use AutoLoader 'AUTOLOAD';

sub new {
  my $class = shift;

  my $config = $system->config;
  
  my $in = {
    # prefix that will be prepended to all cookies
    cookies_prefix  => true($config->get('cookies_prefix')) ? $config->get('cookies_prefix') : '',
    # we will try to store temporary files here
    temp_path       => $system->path.'/private/system/temp',
    # maximum size of the submitted (form) data
    form_max_size   => true($config->get('form_max_size')) ? $config->get('form_max_size') : 1048576,
    # size of the read block for multipart forms
    form_block_size => 4096,    
  };

  my $self = bless($in, $class);
  $self->_get_cookies;
  $self->_get_query;
  return $self;
}

sub query {
  my ($self, @params) = @_;

  # if the key is not defined we return all keys from the query
  return keys %{$self->{query}} if not @params;

  my $first_key = $params[0];

  if (@params > 1) {
    while (@params) {
      my ($key, $value) = splice(@params, 0, 2);
      next if false($key);

      # setting the value to the key, value can be a ref to an array
      if (defined $value) {
        if (ref $value eq 'ARRAY') {
          $self->{query}->{$key} = $value;
        } else {
          $self->{query}->{$key} = [$value];
        }
      } else {
        delete $self->{query}->{$key};
      }
    }
  }

  return undef if not $self->{query}->{$first_key};

  if (wantarray) {
    return @{$self->{query}->{$first_key}};
  } else {
    return $self->{query}->{$first_key}->[0];
  }  
}

sub cookie {
  my ($self, @params) = @_;
  if (not @params) {
    return map {$_ =~ s/^$self->{cookie_prefix}//; $_} keys %{$self->{cookies}};
  }

  my $cookie = $params[0];

  if (@params > 1) {
    while (@params) {
      my ($key, $value) = splice(@params, 0, 2);
      if (true($key) and defined $value) {
        $self->{cookies}->{$self->{cookies_prefix}.$key} = $value;
      }
    }
  }
  return $self->{cookies}->{$self->{cookies_prefix}.$cookie};
}

sub _get_cookies {
  my $self = shift;

  my $cookies = $ENV{HTTP_COOKIE} || $ENV{COOKIE};
  return if not $cookies;

  foreach my $cookie (split(/;\s*/, $cookies)) {
    my ($name, $value) = split (/\s*=\s*/, $cookie);
    $value = decode_url($value);
    $self->{cookies}->{$name} = $value;
  }
}

sub _get_query {
  my $self = shift;

  # command line parameters
  if (@ARGV) {
    foreach my $item (@ARGV) {
      my ($name, $value) = $item =~ /^--(.+?)=["']*(.+)["']*$/;
      next if false($name) or false($value);
      push @{$self->{query}->{$name}}, $value;
    }
  } 

  # form submitted with get or with post and get combined, this should be
  # before multipart form processing below because query string might contain
  # special flags (X-Progress-ID) for the multipart processing
  if (true($ENV{QUERY_STRING})) {
    my $result = $self->_parse_query($ENV{QUERY_STRING});
    if ($result) {
      $self->{query}->{$_} = $result->{$_} foreach keys %$result;
    }
  }

  if ($ENV{CONTENT_LENGTH} and $ENV{CONTENT_LENGTH} > $self->{form_max_size}) { 
    die "Length of the submitted content is larger then the allowed $self->{form_max_size} bytes!";
  }

  # multi-part formdata
  if ($ENV{REQUEST_METHOD} and $ENV{REQUEST_METHOD} eq 'POST' and $ENV{CONTENT_TYPE} and $ENV{CONTENT_TYPE} =~ /^multipart\/form-data/) {
    $self->_parse_multipart;
  }

  # form submitted with post
  if ($ENV{REQUEST_METHOD} and $ENV{REQUEST_METHOD} eq 'POST' and $ENV{CONTENT_LENGTH}) {
    binmode STDIN;
    read(STDIN, $self->{__stdin}, $ENV{CONTENT_LENGTH});
    my $result = $self->_parse_query($self->{__stdin});
    if ($result) {
      $self->{query}->{$_} = $result->{$_} foreach keys %$result;
    }
  }
}

sub _parse_query {
  my $self = shift;
  my $string = shift or return {};

  # removing a potential anchor link from the end of the query string
  $string =~ s/#(.+)$//g;
  
  my ($key, $value, $buffer, $query);
  my @pairs = split(/&/, $string);

  foreach (@pairs) {
    ($key, $value) = split (/=/, $_);
    $key = decode_url($key);
    $value = decode_url($value);
    $value = undef if $value =~ /^\s+$/o; 
    # skipping parameter with an empty value
    next if false($value);
    push @{$query->{$key}}, $value;
  }

  return $query;
};

__END__

sub check_temp_path {
  my $self = shift;
  
  if (true($self->{temp_path}) and not -d $self->{temp_path}) {
    mkdir $self->{temp_path}, 0777 || die "Directory for storing temporary files [ $self->{temp_path} ] doesn't exist and we can't create it: $!";
  }
  
  return 1;
}

sub get_upload_info {
  my $self = shift;
  my $in = {
    upload_id => undef,
    @_
  };
  my $upload_id = $in->{upload_id};
  return undef if false($upload_id);

  my $config_file = (true($self->{temp_path}) ? $self->{temp_path}.'/' : '').'__form_uploads/'.$upload_id.'/info.cgi';
  
  require FWork::System::Config;
  my $config = FWork::System::Config->new($config_file); 
  
  return $config->get_all;
}

sub get_upload_id {
  my $self = shift;
  $self->check_temp_path;
  my $uploads_dir = (true($self->{temp_path}) ? $self->{temp_path}.'/' : '').'__form_uploads';
  
  if (not -d $uploads_dir) {
    mkdir $uploads_dir, 0777 || die "Directory for form uploads [ $uploads_dir ] doesn't exist and we can't create it: $!";    
  }

  # removing upload directories which are more then 24 hours old
  my $threshold_sec = time()-24*60*60;

  opendir(DIR, $uploads_dir) || die "Can't open form uploads directory [ $uploads_dir ] for reading: $!";
  my @old_dirs = map {"$uploads_dir/$_"} grep {
    $_ !~ /^\.+$/ and -d "$uploads_dir/$_" and (stat("$uploads_dir/$_"))[9] < $threshold_sec  
  } readdir(DIR);
  closedir(DIR);
  
  if (@old_dirs and eval {require File::Path}) {
    foreach my $dir (@old_dirs) {
      File::Path::rmtree($dir);
    }
  }
  
  require FWork::System::Utils;
  
  my $dir_exists = 1;
  my $upload_id = undef;
  while ($dir_exists) {
    $upload_id = FWork::System::Utils::create_random(10);
    if (mkdir($uploads_dir.'/'.$upload_id), 0777) {
      $dir_exists = undef;
    } 
  }
  
  return $upload_id;
}

sub get_query_as_url {
  my $self = shift;
  return '' if not $self->{query};
  
  require FWork::System::Utils;
  
  my @query;
  foreach my $key (keys %{$self->{query}}) {
    foreach my $value (@{$self->{query}->{$key}}) {
      push @query, FWork::System::Utils::encode_url($key).'='.FWork::System::Utils::encode_url($value);
    }
  }
  
  return join('&', @query);
}

sub find_query {
  my ($self, $key) = @_;
  return '' if false $key;

  my @found = ();
  foreach my $query (keys %{$self->{query}}) {
    next if $query !~ /$key/;
    push @found, $query;
  }
  return @found;
}

sub file {
  my ($self, $file) = @_;
  return keys %{$self->{files}} if not defined $file;
  return $self->{files}->{$file};
}

sub _parse_multipart {
  my $self = shift;
  
  $self->{__upload_path} = 
    (true($self->{temp_path}) ? $self->{temp_path}.'/' : '') .
    (true($self->query('X-Progress-ID')) ? '__form_uploads/'.$self->query('X-Progress-ID').'/' : '');  

  my $config;
  
  my $save_value = sub {
    my ($part, $value, $content_read, $the_end) = (@_);
    return if not defined $part or not defined $value;
    
    # if the current part is a file then we write value to the file
    if ($part->{filename}) {
      if (not $part->{file}) {
        $self->check_temp_path;
        
        my $tmp_filename = create_random().'.form';
        
        # if temporary path exists we create the temporary file in it, 
        # otherwise we will try to create the file in the current directory
        # (whatever it is)
        my $tmpfile = $self->{__upload_path}.$tmp_filename;
          
        $part->{file} = FWork::System::File->new($tmpfile, "w", {is_temp => 1}) || die "Can't open file $tmpfile for writing: $!";
        binmode $part->{file}->handle;
        
        $part->{__full_tmp_path} = $tmpfile;
        $part->{__tmp_filename} = $tmp_filename;
        
        # starting processing another file
        if ($config and not $the_end) {
          $config->set(currently_uploading => {
            full_tmp_path => $part->{__full_tmp_path},
            tmp_filename  => $part->{__tmp_filename},
            filename      => $part->{filename},
            input_name    => $part->{name},
          });
        }
      }
      syswrite $part->{file}->handle, $value, length($value);
      
      if ($config) {
        # finished processing another file
        if ($the_end) {
          $config->set(currently_uploading => undef);
  
          my $uploaded_files = $config->get('uploaded_files') || [];
          push @$uploaded_files, {
            full_tmp_path => $part->{__full_tmp_path},
            tmp_filename  => $part->{__tmp_filename},
            filename      => $part->{filename},
            input_name    => $part->{name},
          };
  
          $config->set(uploaded_files => $uploaded_files);
        }
        
        $config->set(
          content_read  => $content_read,
          current_time  => time() 
        )->save;
      }
    } else {
      # if the current part is not a file then we just save the value
      $part->{value} .= $value;
    }
    return $part;
  };

  my ($boundary) = $ENV{CONTENT_TYPE} =~ /boundary=\"?([^\";,]+)\"?/;
  $boundary = "--" . $boundary;

  # bytes required to keep in a tail in order to find splitted boundary
  my $req = length($boundary);

  die "Malformed multipart POST!" if $ENV{CONTENT_LENGTH} <= 0;

  if (true($self->query('X-Progress-ID'))) {
    require FWork::System::Config;
    $config = FWork::System::Config->new($self->{__upload_path}.'info.cgi');
    $config->set(
      content_length => $ENV{CONTENT_LENGTH},
      upload_started => time()
    )->save;
    
    $system->on_destroy(sub {
      unlink $self->{__upload_path}.'info.cgi';
      # rmdir will only delete a directory if it is empty, just what we need
      rmdir substr($self->{__upload_path}, 0, -1);
    });
  }

  my ($crlf, $pos, $part, $parts, $content);
  my $mode = "start";

  my $block_size = $self->{form_block_size};
  $block_size = 4096 if not $block_size or $block_size <= 0;
  
  my $content_read = 0;

  binmode STDIN;

  BUFFER: while (read(STDIN, my $buffer, $block_size)) {

    $content_read += length($buffer);
    
    $content .= $buffer;

  CONTENT: while (length($content) > 0) {
      if ($mode eq "start") {
        $pos = index($content, $boundary);
        next BUFFER if $pos < 0 or length($content) < length($boundary)+2;
        # first boundary, we also assigning crlf here
        ($crlf) = $content =~ /^$boundary(\015\012?)/;
        substr($content, 0, length($boundary)+length($crlf)) = "";
        $mode = "header";
        next CONTENT;
      }

      if ($mode eq "header") {
        $pos = index($content, "$crlf$crlf");
        # no $crlf found in the content - read from STDIN further
        next BUFFER if $pos < 0;
        # crlfx2 found, parse the header and switch into "value" mode
        my $top = substr($content, 0, $pos);
        foreach my $line (split(/$crlf/, $top)) {
          my ($name, $value) = $line =~ /^([^:]+):\s+(.+)$/;
          $part->{header}->{$name} = $value;
        }
        ($part->{name}) = $part->{header}->{'Content-Disposition'} =~ /\s+name="?([^\";]*)"?/;
        ($part->{filename}) = $part->{header}->{'Content-Disposition'} =~/\s+filename="?([^\"]*)"?/;
        
        # if this part is a file, then we get the filename from the full path 
        # that some browsers specify, we are also killing all spaces in the name
        if (true($part->{filename})) {
          ($part->{filename}) = $part->{filename} =~ /([^\\\/\:]+)$/;
          $part->{filename} =~ s/\s+//g;
        }

        substr($content, 0, $pos+(length("$crlf$crlf"))) = "";
        $mode = "value";
        next CONTENT;
      }

      if ($mode eq "value") {
        my $fusion = (defined $part->{tail} ? $part->{tail} : "") . $content;
        $pos = index($fusion, $boundary);
        if ($pos >= 0) {
          # we found the end of the current value, so we are switching to 
          # header mode once again and reiterate but only if this is not
          # the last boundary
          $save_value->($part, substr($fusion, 0, $pos-length($crlf)), $content_read, 1);
          
          $part->{file}->close if $part->{file};
          
          push @$parts, $part; 
          $part = {};
          if (index($fusion, "--", $pos) == 0) {
            # we found the very last boundary so we are finishing
            last BUFFER;
          }
          # we might be on the very last edge of boundary and no $crlf was
          # yet read for this boundary, so we figure out how much we need
          # to read from STDIN to skip crlf and just do it
          my $cut = $pos+length($boundary.$crlf);
          if ($cut > length($fusion)) {
            my $to_remove = $cut - length($fusion);
            $cut -= $to_remove;
            read(STDIN, my $buffer, $to_remove);
          }
          substr($fusion, 0, $cut) = "";
          $content = $fusion;
          $mode = "header";
          next CONTENT;
        } else {
          # boundary not found, so we do something with the current value 
          # and reiterate
          if ($req >= length($content)) {
            $part->{tail} = "" if not defined $part->{tail};
            my $len = length($part->{tail}) - $req;
            if ($len > 0) {
              $save_value->($part, substr($part->{tail}, 0, $len), $content_read);
              substr($part->{tail}, 0, $len) = "";
            }
            $part->{tail} .= $content;
          } else {
            my $len = length($content) - $req; # at least 1 or greater
            $part->{tail} .= substr($content, 0, $len);
            $save_value->($part, $part->{tail}, $content_read);
            $part->{tail} = substr($content, -$req);
          }
          $content = "";
          next BUFFER;
        }

      }
    }
  }
  
  $config->set(upload_finished => 1)->save if $config;

  foreach my $part (@$parts) {
    if ($part->{name} and true($part->{value}) and not $part->{filename}) {
      push @{$self->{query}->{$part->{name}}}, $part->{value};
    } 
    
    # saving file information
    elsif ($part->{name} and $part->{filename}) {
      $self->{files}->{$part->{name}} = $part;
      push @{$self->{query}->{$part->{name}}}, $part;
    }
  }
}

sub restore_input_from_disk {
  my $self = shift;
  my $in = {
    dir => undef, # physical path to the directory where the input is currently stored
    @_
  };
  my $dir = $in->{dir};
  return undef if false($dir);

  require FWork::System::File;
  require Storable;

  my $input_file = $dir.'/input.storable';
  my $save = FWork::System::File->new($input_file, 'r') || die "Can't open file $input_file for reading: $!";
  my $input = Storable::thaw($save->contents);
  $save->close;
  
  unlink($input_file);
  
  $self->{$_} = FWork::System::Utils::clone($input->{$_}) for keys %$input;
  
  if ($self->{files}) {
    $self->check_temp_path;
    
    foreach my $name (keys %{$self->{files}}) {
      my $file = $self->{files}->{$name};
      next if not -f $dir."/$file->{__tmp_filename}";
  
      my $tmp_filename = create_random().'.form';
      my $tmpfile = $self->{__upload_path}.$tmp_filename;
      
      FWork::System::Utils::cp($dir."/$file->{__tmp_filename}", $tmpfile);
      unlink($dir."/$file->{__tmp_filename}");

      $file->{file} = FWork::System::File->new($tmpfile, "r", {is_temp => 1}) || die "Can't open file $tmpfile for reading: $!";
      $file->{file}->close;
      
      $file->{__full_tmp_path} = $tmpfile;
      $file->{__tmp_filename} = $tmp_filename;
      
      $self->{query}->{$name} = [$self->{files}->{$name}];
    }
  }
  
  # all files in the directory should be deleted now, so we try to delete the
  # directory, if there are any files left in it, the directory will not be 
  # removed automatically. 
  rmdir($dir);

  return 1;
}

sub save_input_to_disk {
  my $self = shift;
  my $in = {
    dir => undef, # physical path to the directory where the input will be saved
    @_
  };
  my $dir = $in->{dir};
  return undef if false($dir);
  
  require FWork::System::File;
  require Storable;
  
  FWork::System::Utils::create_dirs($dir) if not -d $dir;

  my $input = {map { $_ => FWork::System::Utils::clone($self->{$_}) } qw(__stdin __upload_path query files)};
  if ($input->{files}) {
    foreach my $name (keys %{$input->{files}}) {
      my $file = $input->{files}->{$name};
      FWork::System::Utils::cp($file->{__full_tmp_path}, $dir."/$file->{__tmp_filename}");
      delete $input->{query}->{$name};
      delete $file->{file};
    }
  }

  
  my $input_file = $dir.'/input.storable'; 
  my $save = FWork::System::File->new($input_file, 'w') || die "Can't open file $input_file for writing: $!";
  $save->print(Storable::nfreeze($input))->close;
  
  return 1;
}

sub clean_saved_input {
  my $self = shift;
  my $in = {
    dir => undef, # physical path to the directory where the input is stored on disk
    @_
  };
  my $dir = $in->{dir};
  return undef if false($dir);
 
  my $temp_path = $system->path.'/private/system/temp';
  return undef if not -d $temp_path;

  # remove directories that are older then this number of minutes
  my $old_dir_mins = 10;

  my $current_time = time();
  return undef if not opendir(DIR, $temp_path);

  require File::Path;

  while (my $dir = readdir(DIR)) {
    next if not -d $dir;
    next if $dir !~ /^sid\./;

    # modified time
    my $modified_time = (stat($temp_path.'/'.$dir))[9];
    next if ($current_time - $modified_time) < ($old_dir_mins*60);

    File::Path::rmtree($temp_path.'/'.$dir);
  }

  closedir(DIR);
}

=head1 NAME

FWork::System::Input - Provides access to all input received by the program

=head1 SYNOPSIS

  use FWork::System::Input;
  my $in = FWork::System::Input->new;

  use FWork::System::Input;
  my $in = FWork::System::Input->new(
    cookies_prefix  => 'stuffed_',
    temp_path       => '/home/users/eych/www/temp',
    form_max_size   => 1024*1024*5
  );

  # getting parameter 'action';
  my $action = $in->query('action');

  # if there were several parameters with the name 'action'
  foreach my $action ($in->query('action')) {
    # do something with $action;
  }

  # if you want to get all parameters that were submitted
  foreach my $key ($in->query) {
    # every parameter is accessed through $in->query($key);
    if ($key eq 'action') {
      warn 'Action parameter detected';
    }
  }

=head1 DESCRIPTION

FWork::System::Input is a replacement for a standard CGI.pm module. It shamelessly
borrows some of the technics and interface designs from CGI.pm. 

While CGI.pm provides lots of ways to work with input and output of your Perl
program, FWork::System::Input concentrates exclusively on input and tries to do it 
well and efficient.

=head1 METHODS

The following methods are currently implemented:

=over 

=item query

If called without parameters returns a list of all parameters. 

If called with one parameter, returns the value of this parameter taking into
account the context in which it was called. In the list context all values for
the parameter will be returned (if multiple values exist for this parameter),
in the scalar context one value will always be returned (even if more values
exist for this paramater).

If called with two or more parameters, will assign every second parameter as 
the value of every first parameter. The second parameter can either be a 
scalar or an ARRAY ref (to assign multiple values to one paramater).

IMPORTANT NOTE!

If called with one parameter which doesn't exist (was not specified to us), 
we always return undef. This works great if you are using the method in 
scalar context, but requires some additional code if you are using it in
list context, but only in some situations.

This works correctly when key1 and key2 do not exist:

  my ($var1, $var2) = ($in->query('key1'), $in->query('key2'));

$var1 and $var2 are assigned undef, which is what you should have expected.

However, the example below doesn't work that good if "key" doesn't exist:

  foreach my $key ($in->query('key')) {
  }

You will get inside a loop even if "key" doesn't exist. This happens, because
we always return a value, in this case 'undef'. So you should do a little 
more checking for this to work correctly:

  foreach my $key ($in->query('key')) {
    next if not defined $key;
    # do some magic
  }

  or

  if ($in->query('key')) {
    foreach my $key ($in->query('key')) {
      # do some magic
    }
  }

This design was created on purpose to avoid even more akward situations
with list and scalar context that the author of this module is too lazy
to describe.

=item file

If called without parameters returns a list of all submitted files. 

If called with one parameter, returns the file object (C<FWork::System::File>) for 
this parameter.

=item cookie

If called without parameters returns a list of all cookies. If 
'cookie_prefix' was defined, then it will be stripped from the returning
keys.

If called with one parameter, returns the value of the cookie, which name is
equal to this parameter (possibly prepended with a 'cookie_prefix' if it was
defined when the input object was initialized).

If called with two or more parameters, will assign every second parameter as 
the value of the cookie, which name is equal to every first parameter.

=back

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=head1 SEE ALSO

L<FWork::System::Output>, L<FWork::System::File>.

=cut