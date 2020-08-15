# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 846 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/strip_html_comments.al)"
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
1;
# end of FWork::System::Utils::strip_html_comments
