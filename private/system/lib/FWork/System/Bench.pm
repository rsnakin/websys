package FWork::System::Bench;

$VERSION = 1.00;

use strict;

my $seq = [qw(Time::HiRes Benchmark)];

sub new {
  my $class = shift;
  my $in = {@_};
  my $self = bless({}, $class);

  my $sequence = $in->{seq} || $seq;

  foreach my $class (@$sequence) {
    (my $method = '_'.$class) =~ s/::/_/;
    die "Class \"$class\" is not supported" if not defined &{"FWork::System::Bench::$method"};
    return $self if $self->$method();
  }
}

sub _Time_HiRes {
  my $self = shift;
  eval {require Time::HiRes} || return;
  $self->{start} = [Time::HiRes::gettimeofday()];
  $self->{count} = sub {
    Time::HiRes::tv_interval($self->{start}) . " seconds";
  };
  $self->{raw} = sub {
    Time::HiRes::tv_interval($self->{start});
  };  
  return $self;
}

sub _Benchmark {
  my $self = shift;
  eval {require Benchmark} || return;
  $self->{start} = Benchmark->new;
  $self->{count} = sub {
    (Benchmark::timestr(Benchmark::timediff(Benchmark->new, 
    $self->{start}))) =~ /(\S+\s+CPU)\)$/; $1 . "";
  };
  $self->{raw} = $self->{count};
  return $self;
}

sub as_js {
  my $self = shift;
  my $content  = qq(<script language="javascript"><!--\n);
  $content .= qq(defaultStatus = 'Processing time: );
  $content .= $self->{count}->() . qq(.';\n//--></script>);
  return $content;
}

sub as_text { $_[0]->{count}->() }

sub get_raw { $_[0]->{raw}->() }

1;

__END__

=head1 NAME

FWork::System::Bench - Application benchmarking abstration class

=head1 SYNOPSIS

  use FWork::System::Bench;
  my $t = FWork::System::Bench->new;

  # some code here

  # returns a benchmark string formatted for printing
  print $t->as_text;

  # returns a benchmark string that uses javascript specially for 
  # printing out to the browser
  print $t->as_js;

  # preferred sequence of benchmark modules
  my $t = FWork::System::Bench->new(seq => ['Benchmark', 'Time::HiRes']);

=head1 DESCRIPTION

FWork::System::Bench provides an easy way to benchmark a piece of Perl code or
the whole Perl-based application. 

It uses Time::HiRes (if it is available) or Benchmark modules to do the
tests. Time::HiRes has higher priority because it provides more precise 
results. Unfortunately, it might be unavailable on a particular Perl 
installation. If this is the case, then FWork::System::Bench tries to use Benchmark
module, which should be available everywhere (but its measuring results
are far from being perfect, or, at least, we think so).

You can alter the sequence that FWork::System::Bench uses when trying to load the
modules by giving a reference to an array with module names as a C<seq>
parameter to the method C<new>. This will force FWork::System::Bench to try to
load modules in the order that you specify.

=head1 AUTHOR

Sergey "the Eych" Smirnov, eych@stuffedguys.com

=cut