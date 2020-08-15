# NOTE: Derived from /www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Input;

#line 267 "/www/plazza/cgi-bin/private/system/lib/FWork/System/Input.pm (autosplit into lib/auto/FWork/System/Input/_parse_multipart.al)"
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

# end of FWork::System::Input::_parse_multipart
1;
