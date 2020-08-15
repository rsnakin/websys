# <%text $awaits_approval%>
# <span class="selected"><% $total_comments %></span>
# <%/text%>

use strict;
use vars qw($defs);

$defs->{text} = {
  pattern => qr/\s*\$*([^=\s\%]+)\s*/o,
  handler => \&text,
  version => 1.0,
};

sub text {
  my ($self, $content) = @_;
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my @lines = ();
  my $t = $self->{template};
  my $id = $self->{params}->[0];
  my $final = '';
  
  $id =  $t->compile(template => $id, tag_start => '<', tag_end => '>', raw => 1);

  # preparing for black magic with sprintf
  if (true($content)) {
    $content =~ s/^\s+//s;
    $content =~ s/\s+$//s;
    # variables could be separated either with a new line, or with "@@"
    if ($content =~ /\@\@/) {
      @lines = split(/\@\@/, $content);
    } else {
      @lines = split(/[\n\r]+/, $content);
    }
    foreach (@lines) {
      $_ = $t->compile(template => $_, raw => 1);
    }
    $content = join(', ', @lines);
    $final = '$s->{text}->get('.$id.",$content)";
  } else {
    $final = '$s->{text}->get('.$id.')';
  }

  $self->{raw} ? $t->add_to_raw($final) : $t->add_to_compiled("push \@p,$final;");
}

1;