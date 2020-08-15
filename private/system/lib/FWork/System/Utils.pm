package FWork::System::Utils;

$VERSION = 1.00;

use strict;
use vars qw(@ISA @EXPORT_OK $ERROR);

require Exporter; 
@ISA = qw(Exporter); 
@EXPORT_OK = qw(
  &decode_url &encode_url &addnl2br &br2nl &check_email &clone &convert_time
  &cp &create_dirs &create_random &decode_html &dump &encode_html &in_array 
  &match &name2url &nl2br &nl2space &parse_urls &produce_code &quote &get_ip
  &prepare_float &encode_xml &decode_xml &match_strings &format_thousands
  &text_format &prepare_html_diff &title_case &time_elapsed &cut_string
  &resize_image &pub_file_mod_time &strip_js_comments &strip_html_comments
);

use FWork::System;

sub decode_url {
  my ($string) = @_;
  return "" if not defined $string;
  $string =~ tr/+/ /;
  $string =~ s/%([0-9a-fA-F]{2})/chr hex($1)/ge;
  $string =~ s/\r\n/\n/g;
  return $string;
}

sub encode_url {
  my ($string) = @_;
  return "" if not defined $string;
  $string =~ s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/ge;
  return $string;
}

sub get_ip {
  my $ip;
  
  # if the database is already connected, check the IP in the session
  if ($system->{dbh}) {
    $ip = $system->session->get('__user_ip');
    return $ip if $ip;
  }
  
  if ($ENV{HTTP_X_FORWARDED_FOR}) {
    ($ip) = split(/\s*,\s*/, $ENV{HTTP_X_FORWARDED_FOR});
  }
  if ($ip !~ /^\d+\.\d+\.\d+\.\d+$/) {
    $ip = $ENV{REMOTE_ADDR};
  }
  if ($ip !~ /^\d+\.\d+\.\d+\.\d+$/) {
    $ip = '0.0.0.0'
  }
  return $ip;
}

sub html_entities {
  my $string = shift;
  return undef if false($string);
  
  require HTML::Entities;
  return HTML::Entities::encode_entities($string);
}

use AutoLoader 'AUTOLOAD';
__END__

sub pub_file_mod_time {
  my $url = shift;
  return undef if false($url);
  
  my $pub_path = $system->config->get('public_path'); 
  my $pub_url = quotemeta($system->config->get('public_url'));
  (my $site_root = $pub_path) =~ s/$pub_url$//;
  
  my $file_path = $site_root.$url;
  return $url if not -f $file_path;
  
  $url .= ($file_path =~ /\?/ ? '&' : '?').'__m='.(stat($file_path))[9];
  
  return $url;
}

=head1 time_elapsed($seconds)

Returns a human readable string of how much time has elapsed based on the
provided seconds.

=cut

sub time_elapsed {
  my $elapsed = shift;
  return '0 secs' if not $elapsed;
  
  my $hours = int($elapsed / 60 / 60);
  my $mins = int($elapsed / 60) - $hours*60;
  # seconds could be fractional, so we use int on their value too
  my $secs = int($elapsed - (int($elapsed / 60)*60));

  my $msg;
  if ($hours > 0) {
    $msg .= "$hours hour".($hours != 1 ? 's' : '');
    $msg .= ' ' if $mins > 0 or $secs > 0;
  }
  if ($mins > 0 or ($hours > 0 and $secs > 0)) {
    $msg .= "$mins min".($mins != 1 ? 's' : '');
    $msg .= ' ' if $secs > 0;
  }
  if ($secs > 0) {
    $msg .= "$secs sec".($secs != 1 ? 's' : '');
  }
  
  return $msg;
}

=head1 prepare_html_diff($old_string, $new_string)

Prepares a difference report of two strings in html, shows deleted, updated
and added chars in the new string.

=cut

sub prepare_html_diff {
  my $string_old = shift;
  my $string_new = shift;

  my $seq1 = [split('', $string_old)];
  my $seq2 = [split('', $string_new)];
  
  require Algorithm::Diff;  

  my @diff = Algorithm::Diff::sdiff($seq1, $seq2);
  my $html;
  foreach my $hunk (@diff) {
    # removed
    if ($hunk->[0] eq '-') {
      $html .= '<span style="background-color: #bbb">'.$hunk->[1].'</span>';
    } elsif ($hunk->[0] eq 'u') {
      $html .= $hunk->[1];
    } elsif ($hunk->[0] eq '+') {
      $html .= '<span style="background-color: #cf9">'.$hunk->[2].'</span>';
    } elsif ($hunk->[0] eq 'c') {
      $html .= '<span style="background-color: #ff6">'.$hunk->[2].'</span>';
    }
  }

  return $html;
}

sub format_thousands {
  my $num = shift;
  return $num if not $num or length($num) <= 3;

  my ($fraction) = $num =~ /(\.\d+)$/;
  if (true($fraction)) {
    $num =~ s/\.\d+$//g
  } else {
    $fraction = '';
  }

  my $temp_line_str;
  my @chars = split('', $num);
  while (@chars > 3) {
    my $order3 = pop(@chars);
    $order3 = pop(@chars).$order3;
    $order3 = pop(@chars).$order3;            
    
    $temp_line_str = ','.$order3.$temp_line_str
  }

  return join('', @chars).$temp_line_str.$fraction;  
}

=head1 prepare_float($float_value)

Prepares float value (usually) submitted via a web form for saving in the database.

=cut

sub prepare_float {
  my $value = shift @_;
  return if not defined $value;

  $value =~ s/,/\./g;
  $value =~ s/[^\d\.]//g;

  return $value;
}

sub addnl2br {
  my @strings = @_;
  return if not @strings;
  foreach (@strings) { next if not defined; s/<br\/?>/<br\/>\n/sg; }
  return wantarray ? @strings : $strings[0];
}

sub br2nl {
  my @strings = @_;
  return if not @strings;
  foreach (@strings) { next if not defined; s/<br>/\n/sg; }
  return wantarray ? @strings : $strings[0];
}

sub check_email { ($_[0] || return) =~ /^[^\@\s,;]+\@[^\.\s,;]+\.[^\s,;]+$/ }

=head1 clone

Makes complete copy of the data structure. Uses Storable which should be
installed.

=cut

sub clone {
  my $data = shift;
  return $data if not ref $data;

  require Storable;
  return Storable::dclone($data);
}

=head1 convert_time I<direction>, I<time>

Can convert time between three zones: system, user and gmt. Prefers to use 
$system->user->profile('timezone') to get user's timezone. If false value 
will be returned (possibly, user.cookie pkg is used) then it takes the 
value from $system->config->get('users_timezone').

One of these variables must be defined.

Example:

    # to save the time in the db in gmt format
    FWork::System::Utils::convert_time('sys2gmt'); 

    # converts time from the db to user's local time
    FWork::System::Utils::convert_time('gmt2usr', $time_from_db);

    # converts time from user's localtime to gmt 
    FWork::System::Utils::convert_time('usr2gmt', $time_from_user);

=cut

sub convert_time {
  my ($direction, $time) = @_;
  return if not $direction;
  $time = time if $direction =~ /^sys2gmt|sys2usr$/;
  return if not $time;

  my ($sys_zone, $usr_zone) = (0, 0);
  
  return $time-($sys_zone*60*60) if $direction eq 'sys2gmt';
  return $time-(($sys_zone-$usr_zone)*60*60) if $direction eq 'sys2usr';
  return $time+($sys_zone*60*60) if $direction eq 'gmt2sys';
  return $time-(($usr_zone-$sys_zone)*60*60) if $direction eq 'usr2sys';
  return $time-($usr_zone*60*60) if $direction eq 'usr2gmt';
  return $time+($usr_zone*60*60) if $direction eq 'gmt2usr';
}

sub cp {
  my ($source, $target) = @_;

  return if false($source) or false($target);

  # opening files and putting them in the binmode (for Windows)
  my ($s, $t);

  if (ref $source) {
    $s = $source;
    if (not $s->opened) {
      $s->open('r') || die "Can't open file [ " . $s->name . " ] for reading: $!";
    } elsif ($s->mode ne 'r') {
      die "Source file should be in a read mode!";
    }
  } else {
    $s = FWork::System::File->new($source, 'r') || die "Can't open file [ $source ] for reading: $!";
  }

  if (ref $target) {
    $t = $target;
    if (not $t->opened) {
      $t->open('w') || die "Can't open file [ " . $s->name . " ] for writing: $!";
    } elsif ($t->mode eq 'r') {
      die "Target file should be in a write, append or update mode!";
    }
  } else {
    $t = FWork::System::File->new($target, 'w') || die "Can't open file [ $target ] for writing: $!";
  }

  binmode $s->handle;
  binmode $t->handle;
  
  # initializing the read counter
  my $read = 0;
  # getting size of the source file
  my ($mode, $size) = (stat($s->name))[2, 7];

  # copying process
  my ($buffer, $to_read, $left);
  while ($read < $size) {
    $left = $size - $read;
    $to_read = ($left > 4096 ? 4096 : $left);
    sysread $s->handle, $buffer, $to_read;
    syswrite $t->handle, $buffer, length($buffer);
    $read += $to_read;
  }

  # done copying, closing files
  $t->close;
  $s->close;

  chmod ($mode & 0777), $t->name;

  return $s, $t;
}

sub create_dirs {
  my ($path, $mode) = @_;
  return if false($path);
  $mode ||= 0777;

  my @dirs = split(/\//, $path); 
  my $newpath = "";
  foreach my $dir (@dirs) {
    if (not -d $newpath.$dir) {
      mkdir $newpath.$dir, $mode || die "Can't create [ $newpath$dir ]: $!!";
    }
    $newpath .= "$dir/";
  }

  return 1;
}

sub create_random {
  my ($length) = shift @_;
  my $options = {
    letters_lc => undef, # use lower case letters
    letters_uc => undef, # use upper case letters
    digits     => undef, # use digits
    @_
  };
  $length = 20 if not $length;

  my $no_options = 1;
  foreach (qw(letters_lc letters_uc digits)) {
    if ($options->{$_}) {
      $no_options = undef;
      last;
    }
  }
  
  my @chars = ();
  push @chars, ('a'..'z') if $no_options or $options->{letters_lc};
  push @chars, ('A'..'Z') if $no_options or $options->{letters_uc};
  push @chars, (0..9) if $no_options or $options->{digits};

  my $string;

  for (my $i = 0; $i < $length; $i++) {
    $string .= $chars[ int(rand(@chars)) ];
  }
  return $string;
}

sub dump { 
  my $data = shift;
  my $options = {@_};
  require Data::Dumper;
  my $dump = Data::Dumper::Dumper($data);
  
  if (true($options->{file})) {
    require FWork::System::File;    
    my $f = FWork::System::File->new($options->{file}, 'w');
    return undef if not $f;
    $f->print($dump)->close; 
    return 1;
  }
  
  my $result = '<pre>'.$dump.'</pre>';
  return $result if $options->{return};
  $system->out->say($result);
  exit if not $options->{no_exit};
}

sub decode_html {
  my @strings = @_;
  return if not @strings;
  my $html = {
    "&lt;" => "<", "&gt;" => ">", "&quot;" => "\"", "&#39;" => "'", 
    "&amp;" => "&"
  };
  foreach (@strings) {
    next if not defined;
    s/(&lt;|&gt;|&quot;|&#39;|&amp;)/$html->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

sub encode_html {
  my @strings = @_;
  return if not @strings;
  my $html = {
    "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;","'" => "&#39;", "\r" => "",
    "&" => "&amp;"
  };
  foreach (@strings) {
    next if not defined;
    s/(<|>|"|'|\r|&)/$html->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

sub decode_xml {
  my @strings = @_;
  return if not @strings;
  my $xml = {
    "&lt;" => "<", "&gt;" => ">", "&quot;" => "\"", "&amp;" => "&"
  };
  foreach (@strings) {
    next if not defined;
    s/(&lt;|&gt;|&quot;|&amp;)/$xml->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

sub encode_xml {
  my @strings = @_;
  return if not @strings;
  my $xml = {
    "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;","&" => "&amp;"
  };
  foreach (@strings) {
    next if not defined;
    s/(<|>|"|&)/$xml->{$1}/go;
  }
  return wantarray ? @strings : $strings[0];
}

=head1 in_array I<element>, I<array>

It will check if scalar C<element> exists in the array C<array>.

Returns 1 when the first occurence of the C<element> inside C<array> is 
found. Otherwise returns false (hopefully).

=cut

sub in_array {
  my ($key, @array) = @_;
  return undef if not defined $key or not @array;
  foreach (@array) { return 1 if $_ eq $key }
}

# match two hashes (order doesn't matter) or plain variables
# returns 1 if their values (and keys) are identical, 0 otherwise
# returns 1 if both vars are not defined or empty
sub match {
  my ($var1, $var2) = @_;

  # two parameters and not defined, so they match
  return 1 if not defined $var1 and not defined $var2;

  # one is a ref, another is not = no match
  return 0 if not ref $var1 and ref $var2;
  return 0 if not ref $var2 and ref $var1;

  # refs on different things, they don't match
  return 0 if (ref $var1 and ref $var2) and (ref $var1 ne ref $var2);

  if (ref $var1 eq 'HASH') {
    # different number of keys in the hash - they don't match
    return 0 if scalar(keys %$var1) != scalar(keys %$var2);

    foreach my $key (%$var1) {
      if (not ref $var1->{$key}) {
        return 0 if $var1->{$key} ne $var2->{$key};
      } elsif (not match($var1->{$key}, $var2->{$key})) {
        return 0;
      }
    }
  } elsif (ref $var1 eq 'ARRAY') {
    # different number of elements in array - they don't match
    return 0 if scalar @$var1 != scalar @$var2;
    
    for (my $i = 0; $i <= $#{$var1}; $i++) {
      if (not ref $var1->[$i]) {
        return 0 if $var1->[$i] ne $var2->[$i];
      } elsif (not match($var1->[$i], $var2->[$i])) {
        return 0;
      }
    }
  } elsif (not ref $var1) {
    return 0 if $var1 ne $var2;
  } else {
    # a ref that we don't support (we only support HASH and ARRAY)
    return 0;
  }

  return 1;
}

sub name2url { 
  my $name = shift;
  return '' if false($name);
  # removing all charachters that are not letters, digits, points
  $name =~ s/[^\w\.\d]/_/g;
  # also forcing lower case
  return lc($name);
}

sub nl2br {
  my @strings = @_;
  return if not @strings;
  foreach (@strings) { next if not defined; s/\n\r?/<br\/>/sg; }
  return wantarray ? @strings : $strings[0];
}

sub nl2space {
  my @strings = @_;
  return if not @strings;
  foreach (@strings) { next if not defined; s/\n\r?/ /sg; }
  return wantarray ? @strings : $strings[0];
}

sub parse_urls {
  my ($string) = @_;
  return if false($string);

  $string =~ s/((?:https?|ftp):\/\/[\w\.\-]+)/<a href="$1">$1<\/a>/sg;
  $string =~ s/([^\/])(www\.[\w\.\-]+)/$1<a href="http:\/\/$2">$2<\/a>/sg;
  $string =~ s/([\.\w\-]+@[\.\w\-]+\.[\.\w\-]+)/<a href="mailto:$1">$1<\/a>/sg;

  return $string;
}

=head1 product_code(ARRAY_REF|HASH_REF, [spaces => 1])

If "spaces" parameter is specified then everything in the data structure
that will be created (keys, values, etc) will be separated with single spaces.
This is more readable and is meant to be used for information that might
be presented to the end user.

If "json" parameter is specified '=>' is substituted with ':' and "undef" with 
"null".

=cut

sub produce_code {
  my ($data, $options) = (shift, {@_});
  
  my $space = $options->{spaces} ? ' ' : '';
  my $arrow = $options->{json} ? ':' : '=>';

  return ($options->{json} ? 'null' : 'undef') if not defined $data;
  return quote($data) if false($data) or not ref $data;

  if ($options->{allow_blessed}) {
    delete $options->{allow_blessed} if not eval "require Scalar::Util";
  }
  
  my $result;
  my $ref_type = ($options->{allow_blessed} ? Scalar::Util::reftype($data) : ref $data);
  
  if ($ref_type eq 'HASH') {
    my @items = ();
    foreach (keys %$data) {
      push @items, quote($_).$space.$arrow.$space.produce_code($data->{$_}, %$options);
    }
    $result = '{'.join(",$space", @items).'}';
  } elsif ($ref_type eq 'ARRAY') {
    my @items = ();
    foreach (@$data) {
      push @items, produce_code($_, %$options);
    }
    $result = '['.join(",$space", @items).']';
  }
  
  return $result;
}

=head1 quote(STRING, START_QUOTE, [ END_QUOTE ])

  # quoting a string with double quotes
  my $str = FWork::System::Utils::quote('a string with "double quotes"', q("));

  # returns "a string with \"double quotes\""
  print $str;

This is a universal quoting function that can use any two single characters as
quotes. The main purpose of the function is to escape the quoting characters
properly inside the STRING.

End quoting character is optional. If it is not specified, then we use the
start quoting chracter for the end quote.

Start quoting character is optional too. If it is not specified then we use 
single quotes as the default quoting characters - '';

=cut

sub quote {
  my ($string, $start, $end, $no_border) = @_;
  $start = "'" if false($start);
  $end = $start if false($end);
  if (false($string)) {
    return if $no_border; 
    return $start.$end if not $no_border;
  }

  # escaping quoting characters and the escaping '\' itself inside the string
  $string =~ s/([\\$start$end])/$1 eq '\\' ? "\\\\" : "\\$1"/sge;

  return ($no_border ? '' : $start) . $string .  ($no_border ? '' : $end);
}

sub match_strings {
  my $string1 = shift;
  my $string2 = shift;
  
  $string1 =~ s/^\s+//;
  $string1 =~ s/\s+$//;
  $string2 =~ s/^\s+//;  
  $string2 =~ s/\s+$//;
  
  # turning a string into an array and converting everything to lowercase
  my @words1 = map {lc($_)} split(/[\r\n\s]+/, $string1);
  my @words2 = map {lc($_)} split(/[\r\n\s]+/, $string2); 
  
  return 0 if not @words1 or not @words2;
  
  # We need to calculate
  # 1. How many words from the first array have a match in the second array
  # 2. The same for the second array, matching words in the first array
  # 3. We need to take into account repeating words (2 repeating words in 
  #    the first array do not match 1 word in the second, only 1 word does).

  my ($words1_idx, $words2_idx);
  
  $words1_idx->{$_} += 1 foreach @words1;
  $words2_idx->{$_} += 1 foreach @words2;  

  my $matched;
  
  foreach my $word (@words1) {
    next if not $words2_idx->{$word};
    $matched += 1;
    $words2_idx->{$word} -= 1;
  }
  
  foreach my $word (@words2) {
    next if not $words1_idx->{$word};
    $matched += 1;
    $words1_idx->{$word} -= 1;
  }
  
  my $total_words = @words1 + @words2;  
  my $match_percent = sprintf("%.2f", $matched / ($total_words / 100));
   
  return $match_percent;
}

sub text_format {
  my $txt = shift;
  my $length = shift;
  
  $txt =~ s/\r//g;
  my @lines = split(/\n/, $txt);
  my @formatted;
  
  while (@lines) {
    my $line = shift @lines;
    if (length($line) > $length and (my $index = index($line, ' ', $length)) > -1) {
      push @formatted, substr($line, 0, $index);
      unshift @lines, substr($line, $index+1)
    } elsif ($line ne '' and @lines and $lines[0] ne '') {
      $lines[0] = $line.' '.$lines[0];
    } else {  
      push @formatted, $line;
    }
  }
  
  return join("\n", @formatted);
}

sub title_case {
  my $string = shift;
  return $string if false($string);

  # generating a unique string with 20 lower case letters, which we will use 
  # to mark artifically inserted spaces, which we will need to cut out at the end
  my $cut_id;
  while (not defined $cut_id or $string =~ /$cut_id/) {
     $cut_id = create_random(20, letters_lc => 1);
  }
  
  my $split_chr = quotemeta('.,!-/()\\[]"');
  
  $string =~ s/([$split_chr])(\S)/$1$cut_id $2/g;
  my @words = split(/\s+/, $string);
  
  for (my $i = 0; $i < scalar @words; $i++) {
    # if the word contains a number then we think this is a postcode or
    # something similar and keep the original case of the word
    next if $words[$i] =~ /\d/;
    $words[$i] = ucfirst(lc($words[$i]));      
  }
  
  $string = join(' ', @words);
  $string =~ s/$cut_id\s//g;
  
  return $string;
}

sub cut_string {
  my $string = shift;
  my $length = shift;
  return '' if false($string) or not $length;
  return $string if length($string) <= $length;
  
  my $sub_string = substr($string, 0, $length);
  my $next_chr = substr($string, $length-1, 1);

  # ends with a space already
  if ($sub_string =~ /\s+$/) {
    $sub_string =~ s/\s+$//s;
  } 

  # next character in line was space or full stop
  elsif ($next_chr eq ' ' or $next_chr eq '.') {
    $sub_string =~ s/\s+$//s;
  }
  
  # we are probably in the middle of the word
  else {
    $sub_string =~ s/\s+\S+$//s;
  }
  
	$sub_string .= '...'; 
  
  return $sub_string;
}

sub resize_image {
  my $in = {
    image_data      => undef, # required, binary image data
    width           => undef, # required, target width of image
    height          => undef, # required, target height of image
    exact           => undef, # optional flag, that will force the width and
                              # height specified, cropping the image if required
    accept_formats  => undef, # optional, array ref of file formats that should 
                              # be accepted (jpeg, gif, etc)
    @_
  };
  
  my $image_data = $in->{image_data};
  my $width = $in->{width};
  my $height = $in->{height};   
  my $exact = $in->{exact};
  my $accept_formats = $in->{accept_formats};
  return undef if false($image_data) or false($width) or false($height);
  
  # if Image::Magick failed to load we just return the original data
  eval {require Image::Magick} || return $image_data;  

  my $image = Image::Magick->new;
  $image->BlobToImage($image_data);

  my ($x, $y, $format) = map {lc($_)} $image->Get('columns', 'rows', 'magick');

  if (ref $accept_formats eq 'ARRAY') {
    my $accept_idx = {map {lc($_) => 1} @$accept_formats};
    return undef if not $accept_idx->{$format};  
  }
  
  # no transformations required, returning image back
  if ($x <= $width and $y <= $height) {
    return $image_data;
  }

  my $geometry;
  if ($exact) {
    if ($x > $y) {
      $geometry = 'x'.$height;
    } else {
      $geometry = $width.'x';
    }
  } else {
    $geometry = $width.'x'.$height;
  }
  $image->Resize(geometry => $geometry);

  # returning back with a new image, if exact size is not required, otherwise
  # continue with cropping
  if (not $exact) {
    my @blobs = $image->ImageToBlob;
    return image => $blobs[0];
  }

  # new x and y sizes
  ($x, $y) = $image->Get('columns', 'rows');

  # cropping image now because the size is still not exact
  if ($x != $width || $y != $height) {
    $geometry = $width.'x'.$height;
    if ($x > $y) {
      my $x_offset = int(($x - $width) / 2);
      $geometry .= '+'.$x_offset.'+0';
    } else {
      my $y_offset = int(($y - $height) / 2);
      $geometry .= '+0+'.$y_offset;
    }
    $image->Crop($geometry);
  }
  
  my @blobs = $image->ImageToBlob;
  return $blobs[0];
}

sub strip_js_comments {
  my $content = shift;
  return $content if false($content);

  # only remove JS comments, correctly doesn't remove //--> (requires $1$2$3 substitution)
  # $content should only have the JS code for this regexp to work correctly
  my $js_comments = qr!
    (
        [^"'/]+ |
        (?:"[^"\\]*(?:\\.[^"\\]*)*"[^"'/]*)+ |
        (?:'[^'\\]*(?:\\.[^'\\]*)*'[^"'/]*)+
    ) |
    
    (//\s*-->) |
    
    /
    (?:
      \*[^*]*\*+ (?: [^/*][^*]*\*+ )*/\s*\n?\s* |
      /[^\n]*(\n|$)
    )
  !xo;  
  
  $content =~ s/$js_comments/$1$2$3/sg;
  
  return $content;
}

sub strip_html_comments {
	my $in = {
		html			=> undef,
		filename	=> undef,
		@_
	};
	my ($html, $filename) = map {$in->{$_}} qw(html filename);
	return undef if not $filename or $filename !~ /\.html?$/i;
	
	# trying to get file contents if they haven't been passed
	if (not defined $html and -f $filename) {
		require FWork::System::File;
		my $f = FWork::System::File->new($filename, 'r') || die $!;
		$html = $f->contents;
		$f->close;
	}

	return $html if false($html)
									or not $system->config->get('strip_html_comments')
									or not eval {require HTML::Parser};

	# stripping html comments
	my $stripped_html;

	my $script_text = sub {
		my $text = shift;
		$stripped_html .= strip_js_comments($text);
	};
	
	my $end_script_text = sub  {
		my ($self, $tagname, $text) = @_;
		return if ($tagname ne 'script');
		$stripped_html .= $text;
		$self->handler("text", undef);
		$self->handler("end", undef);
	};
	
	my $start_handler = sub {
		my ($self, $tagname, $text) = @_;
		$stripped_html .= $text;
		return if ($tagname ne 'script');
		$self->handler(text => $script_text, "text");
		# we should set "text" handler back to default one after processing <script> inner text
		# - so we'll do this in the "end" handler
		$self->handler(end => $end_script_text, "self, tagname, text");
	};

  # conditional comment start
  # <!--[if (gt IE 5)&(lt IE 7)]>
	
	HTML::Parser->new(
		api_version => 3,
		handlers	=> [
				default => [sub { $stripped_html .= shift }, 'text'],
				comment => [sub {
				  my $text = shift;
				  if ($text =~ /^<!\-\-\[[^\]]+\]>/) {
  					$stripped_html .= $text;
				  }  
				}, 'text' ],
				start	=> [$start_handler, 'self, tagname, text'],
		],
	)->parse($html)->eof || die "Error while stripping html comments from file $filename: $!";

	return $stripped_html;
}

1;
