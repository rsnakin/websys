use strict;
use FWork::System;
use utf8;
use EWZ;

sub ewz {
  my $self = shift;
  my $in = $system->in;
=pod
  foreach my $i (2..9) {

    system('wget http://odessa3.org/collections/war/ewz/link/ewzmisc' . $i . '.txt');

  }
=cut
  my $ewz = EWZ->new();

  my $list = $ewz->get_lists();

  # $system->dump($list, no_exit => 1);
  my $n = 0; my $nl = 0;
  foreach my $l (sort {$a->{path} cmp $b->{path}} @$list) {
    # $n ++;
    # if($n > 500) {$system->stop();}
    open(fl, '<'. $l->{path});
    my $start = 0;
    my $LastFirst;
    my $DM;
    my $Year;
    my $BirthPlace;
    my $Film;
    my $Frame;
    my $Remarks;
    # my $nl = 0;
    while(my $r = <fl>) {
      # next if $r =~ /ˆ\s+?\n/;
      if($start == 0) {
        $LastFirst = index($r, 'Last, First');
        if($LastFirst == 0) {
          $DM = index($r, 'D/M');
          $Year = index($r, 'Year');
          $BirthPlace = index($r, 'Birth Place');
          $Film = index($r, 'Film');
          if($Film < 0) {
            $Film = index($r, 'film');
          }
          $Frame = index($r, 'Frame');
          if($Frame < 0) {
            $Frame = index($r, 'Page');
          }
          $Remarks = index($r, 'Remarks');
          if($Year < 0) {
            $Year = $DM + 6;
          }
          if($BirthPlace < 0) {
            $BirthPlace = $Year + 5;
          }
          # print "$l->{path}, $LastFirst, $DM, $Year, $BirthPlace, $Film, $Frame, $Remarks\n";
          # print "\n$l->{path}\n";
          $start = 1;
          next;
        }
      }
      if($start == 1) {
        $r =~ s/\n//g;
        my $tr = $r;
        $tr =~ s/\s//g;
        next if $tr eq '';
        # $r =~ s/\s*(.+?)\s*\n/$1/g;
        my $name = substr($r, 0, $DM - 1);
        next if $name eq '';
        $name =~ s/ //g;
        my ($name, $vorname) = split(',', $name);
        my $date = substr($r, $DM-1, $Year - $DM);
        my ($tag, $monat) = split(' ', $date);
        my $year = substr($r, $Year, $BirthPlace - $Year);
        $year =~ s/ //g;
        $year = int($year);
        my $ort = substr($r, $BirthPlace-1, $Film - $BirthPlace);
        $ort =~ s/\s*(.+?)\s*$/$1/g;
        $ort =~ s/\s(.*)/$1/g;
        my $film = substr($r, $Film, $Frame - $Film);
        $film =~ s/\s*(.+?)\s*$/$1/g;
        my $frame = substr($r, $Frame, $Remarks - $Frame);
        $frame =~ s/\s*(.+?)\s*$/$1/g;
        my $remarks = substr($r, $Remarks);
        $remarks =~ s/\s*(.+?)\s*\n/$1/g;
        # print "($name)($vorname)($tag,$monat,$year)($ort)($film)($frame)($remarks)\n";
        $ewz->save_record(
          name => $name,
          vorname => $vorname,
          tag => int($tag),
          monat => $monat,
          jahr => $year,
          ort => $ort,
          film => $film,
          frame => $frame,
          remark => $remarks,
          record => $r,
          data_file => $l->{path}
        );
        $n ++;
        $nl ++;
        if($nl > 100000) {
          # print "$n\n";
          $nl = 0;
        }
        # if($nl > 4) {
        #   last;
        # }
      }
=pod
          $ewz->save_record(
            name => $arr[0],
            vorname => $arr[1],
            tag => $arr[2],
            monat => $arr[3],
            jahr => $arr[4],
            ort => $arr[5],
            film => $arr[6],
            frame => $arr[7],
            remark => $arr[8] . ' ' . $arr[9] . ' ' . $arr[10] . ' ' . $arr[11] . ' ' . $arr[12] . ' ' . $arr[13] . ' ' . $arr[14]  . ' ' . $arr[15],
            record => $r
          );
=cut
    }
  }
  $ewz->save_orte();

  $system->stop;
}

1;
