use strict;
use FWork::System;
# use utf8;
# use FWork::System::Ajax qw(&return_html);
# use JSON -support_by_pp;

sub pi_cron {
  my $self = shift;
  my $str = `vcgencmd measure_temp`;
  $str =~ /temp=(.*)\'C/;
  my $temp = $1;
  my $time = time();
  my $sth = $system->dbh->prepare('insert into pi_temp set pi_temp = ?, pi_time = ?');
  $sth->execute($temp, $time);
  $sth = $system->dbh->prepare('delete from  pi_temp where pi_time < ?');
  $sth->execute($time - 36000);
#   return_html(to_json($ret));
  $system->stop;
}

1;
__END__

CREATE TABLE `pi_temp` (
  `pi_temp` varchar(64),
  `pi_time` int(20) unsigned NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8
