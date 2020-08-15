package FWork::System::Ajax;

$VERSION = 1.00;

use strict;
use vars qw(@ISA @EXPORT_OK);

use FWork::System;

require Exporter; 
@ISA = qw(Exporter); 
@EXPORT_OK = qw(
	&return_error 
	&return_html
	&return_js
	&return_json
	&decode_value
	&return_template
	&is_ajax_request
);

sub return_error { 
  my $msg = shift;
  my $options = {@_};
  
  my $ajax_version = $ENV{HTTP_X_TWIBO_AJAX_VERSION} || 1;
  if ($ajax_version > 1) {
    $msg = '<div id="__ajax_error_message">'.$msg.'</div>';
    if (ref $options->{fields} and @{$options->{fields}}) {
      require FWork::System::Utils;
      my $quoted_fields = join(',', map {FWork::System::Utils::quote($_)} @{$options->{fields}});
      $msg .= '<div id="__ajax_error_fields">new Array('.$quoted_fields.')</div>'
    }
  }  

  $system->out->header(Status => '500 Internal Server Error') if not $options->{no_headers};  
  $system->out->say($msg);
  $system->config->set(debug => 0);
  $system->stop;  
}

sub return_html { 
  my $msg = shift;
  my $options = {@_};
	$system->out->header('Content-Type' => 'text/html; charset=utf-8');
	$system->out->say($msg);
  $system->config->set(debug => 0);
  $system->stop;  
}

sub return_js { 
  my $msg = shift;
  my $options = {@_};
	$system->out->header('Content-Type' => 'application/x-javascript; charset=utf-8');
	$system->out->say($msg);
  $system->config->set(debug => 0);
  $system->stop;  
}

sub return_json {
  my $hash = shift;
  require FWork::System::Utils;
	$system->out->header('Content-Type' => 'application/x-javascript; charset=utf-8');
	
  my $json = FWork::System::Utils::produce_code($hash, json => 1, allow_blessed => 1);
	
	$system->out->say($json);
  $system->config->set(debug => 0);
  $system->stop;  
}

sub return_template {
	my $pkg = shift;
  my $template = shift;
  return undef if not $pkg or not $template;
  my $options = {@_};
  if (-f $pkg->_skin->path.'/'.$template) {
  	my $content = $pkg->_template($template)->parse($pkg->{vars});
		return_html($content);
  }
  else {
  	return_error('Template is not found');
  }
}

sub decode_value {
	my $value = shift;
	require Encode;
	return Encode::encode("iso-8859-1", Encode::decode("utf8", $value));
}

sub is_ajax_request {
	return $ENV{HTTP_X_REQUESTED_WITH} eq 'XMLHttpRequest';
}

1;