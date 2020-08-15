package FWork::System::DBI::Base::PGSQL;

$VERSION = 1.00;

use strict;
# use utf8;
use FWork::System;

sub new {
  my $class = shift;
  my $in = {
    db_name => undef,
    db_host => undef,
    db_user => undef, # optional
    db_pass => undef, # optional
    @_
  };
  foreach (qw(db_name db_host)) {
    return if false($in->{$_});
  }
  eval { require DBI }; die "Can't load DBI! $@" if $@;
  my $dsn = "DBI:Pg:dbname=$in->{db_name};host=$in->{db_host}";

  my $dbh = DBI->connect($dsn, $in->{db_user}, $in->{db_pass}, {
    AutoCommit=>1,RaiseError=>1,PrintError=>0
# ,pg_utf8_strings=>1 
  });
  
# this can be useful when used in the following configuration:
# html pages are in win1251 encoding and mysql database is in koi8 encoding
# this lines will force mysql to autoconvert all data during input/output
# $dbh->do("set character set cp1251_koi8");

  return $dbh;
}

1;
