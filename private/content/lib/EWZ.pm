package EWZ;
use strict;
use FWork::System;
use JSON -support_by_pp;
use Digest::MD5 qw(md5_hex);
use File::stat;
use utf8;

require FWork::System::Utils;
require FWork::System::File;

sub new {
  my $class = shift;
  my $self = bless({}, $class);
  $self->{ewz_lists} = $system->config->get('ewz_lists');
  $self->{ewz_base} = $system->config->get('ewz_base');
  return $self;
}

sub save_record {
  my $self = shift;
  my $in = {
    name => undef,
    vorname => undef,
    tag => undef,
    monat => undef,
    jahr => undef,
    ort => undef,
    film => undef,
    frame => undef,
    remark => undef,
    record => undef,
    data_file => undef,
    @_
  };

  # if(length($in->{tag}) > 4) {
  #   $system->dump($in);
  # }

  my $sth = $system->dbh->prepare(
    'insert into ewz set '
      . 'name = ?, '
      . 'uc_name = ?, '
      . 'vorname = ?, '
      . 'uc_vorname = ?, '
      . 'tag = ?, '
      . 'monat = ?, '
      . 'jahr = ?, '
      . 'ort = ?, '
      . 'uc_ort = ?, '
      . 'film = ?, '
      . 'frame = ?, '
      . 'remark = ?, '
      . 'record = ?, '
      . 'data_file = ?'
  );
  eval(
  '$sth->execute(
    $in->{name},
    uc($in->{name}),
    $in->{vorname},
    uc($in->{vorname}),
    $in->{tag},
    uc($in->{monat}),
    $in->{jahr},
    $in->{ort},
    uc($in->{ort}),
    $in->{film},
    $in->{frame},
    $in->{remark},
    $in->{record},
    $in->{data_file}
  );');
  if($_) {
    print "$_\n";
    $system->dump($in);
  }
  # my $file = md5_hex($in->{record});
  # my $path = $self->{ewz_base} . '/name/' . join('/', split('', uc($in->{name})));
  # $self->write_record(
    # path => $path,
    # file => $file,
    # data => $in
  # );
=pod
  my $path = $self->{ewz_base} . '/vorname/' . join('/', split('', uc($in->{vorname})));
  $self->write_record(
    path => $path,
    file => $file,
    data => $in
  );
  $in->{ort} =~ s/ /_/g;
  my $path = $self->{ewz_base} . '/ort/' . join('/', split('', uc($in->{ort})));
  $self->write_record(
    path => $path,
    file => $file,
    data => $in
  );
  my $path = $self->{ewz_base} . '/birth/' . $in->{jahr} . '/' . $in->{monat} . '/' . $in->{tag};
  $self->write_record(
    path => $path,
    file => $file,
    data => $in
  );
  my $path = $self->{ewz_base} . '/film/' . join('/', split('', uc($in->{film})));
  $self->write_record(
    path => $path,
    file => $file,
    data => $in
  );
=cut
  # $self->{orte}->{$in->{ort}} ++;
  # print "cd $path\n";
  # $system->dump($path);

  # FWork::System::Utils::create_dirs();
  # $system->dump($path);
}

sub save_orte{
  my $self = shift;
  return;
  open(fl, '>' . $self->{ewz_base} . '/orte.json') || die $self->{ewz_base} . '/orte.json' . "   Error save_orte!\n";
  print fl to_json($self->{orte});
  close(fl);

}

sub write_record {
  my $self = shift;
  my $in = {
    path => undef,
    data => undef,
    file => undef,
    @_
  };
  FWork::System::Utils::create_dirs($in->{path}) || die "Error $in->{path}\n";
  open(fl, '>' . $in->{path} . '/' . $in->{file});
  print fl to_json($in->{data});
  close(fl);
}

sub get_lists {
  my $self = shift;

  opendir(my $dh, $self->{ewz_lists}) || return undef;
  while (my $f = readdir $dh) {
    my $data = stat($self->{ewz_lists} . '/' . $f);
    push @{$self->{lists}}, {
      path => $self->{ewz_lists} . '/' . $f,
      name => $f,
      size => sprintf("%.3fk", $data->size / 1024.)
    } if $f ne '..' and $f ne '.';
  }
  closedir $dh;

  return $self->{lists};
}
1;
__END__

CREATE TABLE `ewz` (
  `name` varchar(128),
  `uc_name` varchar(128),
  `vorname` varchar(128),
  `uc_vorname` varchar(128),
  `tag` varchar(2),
  `monat` varchar(3),
  `jahr` varchar(4),
  `ort` varchar(512),
  `uc_ort` varchar(512),
  `film` varchar(64),
  `frame` varchar(32),
  `remark` varchar(512),
  `record` varchar(1024),
  `data_file` varchar(512)
) ENGINE=MyISAM DEFAULT CHARSET=utf8