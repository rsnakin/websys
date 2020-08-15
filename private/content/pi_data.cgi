use strict;
use FWork::System;
use utf8;
use FWork::System::Ajax qw(&return_html);
use JSON -support_by_pp;

sub pi_data {
  my $self = shift;
  my $in = $system->in;
  my $ret;
  my $limit = $in->query('limit');
  
  $limit = 1000 if not $limit;
  my $sth = $system->dbh->prepare('select * from pi_temp order by pi_time desc limit ' . $limit);
  $sth->execute();
  while(my $line = $sth->fetchrow_hashref) {
    delete $line->{pi_time};
    push @{$ret->{linies}}, $line;
  }
  $ret->{out} = `vcgencmd measure_temp`;
  $ret->{out} =~ /temp=(.*)\'C/;
  $ret->{temp} = $1;
  
  $ret->{hostname} = `hostname`;
  $ret->{date} = `date`;
  $ret->{hostname} =~ s/\n//;
  $ret->{date} =~ s/\n//;
  $system->dump($ret, file => '/var/www/pi_data.dump');

  return_html(to_json($ret));
  $system->stop;
}

1;
