use strict;
use vars qw($defs);

$defs->{var} = {
  pattern => qr/\s*\$([^=\s\%]+)(?:\s+([^\$]+))?\s*/o,
  single  => 1,
  handler => \&var,
  version => 1.0,
};

my $not_complex;

sub var {
  my ($self, $final) = (shift, undef);
  return if not $self->{params} or ref $self->{params} ne 'ARRAY';

  my $t = $self->{template};

  while (@{$self->{params}}) {
    my ($var, $params) = splice @{$self->{params}}, 0, 2;

    my $mods = [];

    if ($params) {
      push @$mods, {type => $1, param => $2} while $params =~ /([^=\s]+)="([^"]+)"/g;
    }

    my ($parsed, $complex);

    # potential complex var
    # note: we aslo create a cache of the complex vars that do not exist
    if (($complex) = $var =~ /([^\.]+)\./ and not $not_complex->{$complex}) { 
      my $o = $t->variable(type => $complex, exp => $var);
      $o ? ($parsed = $o->handle) : ($not_complex->{$complex} = 1);
    }

    # tricky logic below to handle nested variables in this variable
    # most trouble appear becase we might have a nested variable wich
    # will use dot inside to specify several levels that we need to support
    if (not defined $parsed) {
      $var = $t->compile(
        template  => $var, 
        tag_start => '<', 
        tag_end   => '>', 
        raw       => 1, 
      );

      my $parts = [split(/'\.|\.'/, $var)];

      my @line = ();
      my $final_parts = [];
      foreach my $part (@$parts) {
        if ($part !~ /^\$/) {
          $part = "'$part" if $part !~ /^'/;
          $part = "$part'" if $part !~ /'$/;
          my @inside = split(/\./, $part);
          if (@inside > 1) {
            my $first = (shift @inside) . "'";
            push @line, $first;
            push @$final_parts, join('.', @line);
            foreach my $one (@inside) {
              $one = "'$one" if $one !~ /^'/;
              $one = "$one'" if $one !~ /'$/;
              push @$final_parts, $one;
            }
            @line = ();
          } else {
            push @line, $part;
          }
        } else {
          push @line, $part;
        }
      }

      push @$final_parts, join('.', @line) if @line;

      $parsed = "\$v";
      foreach my $line (@$final_parts) {
        $parsed .= "->{$line}";        
      }
    }

    if (true($parsed)) {
      foreach my $mod (@$mods) {
        $parsed = $t->modifier(type => $mod->{type}, param => $mod->{param})->handle($parsed);
      }
      if ($params and $params =~ /or(?:\s+(["'])([^\1]+)\1)?/) {
        $final .= "true($parsed) ? $parsed : ";
        $final .= FWork::System::Utils::quote($2) if defined $2;
      } else {
        $final .= $parsed;
      }
    }
  }

  if (true($final)) {
    $self->{raw} ? $t->add_to_raw($final) : $t->add_to_compiled("push \@p,$final;");
  }
}

1;