use strict;
use FWork::System;
use Issues;
use Structure;
use utf8;

sub issues {
  my $self = shift;
  my $in = $system->in;

  $self->{vars}->{page} = 'issues';

  my $structure = Structure->new()->{jstructure};

  # $system->dump($structure);

  my $issues = Issues->new();
  if($in->query('delete_issue_id')) {
    $issues->delete_issue($in->query('delete_issue_id'));
  }

  foreach my $id (sort {$issues->{issues_base}->{$b}->{date_time} <=> $issues->{issues_base}->{$a}->{date_time}} keys %{$issues->{issues_base}}) {
    # my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($issues->{issues_base}->{$id}->{date_time});
    $issues->{issues_base}->{$id}->{t_path} = $structure->{$issues->{issues_base}->{$id}->{path}}->{name};
    $issues->{issues_base}->{$id}->{t_item} = $structure->{$issues->{issues_base}->{$id}->{path}}->{items}->{$issues->{issues_base}->{$id}->{item}}->{name} if $issues->{issues_base}->{$id}->{item};
    $issues->{issues_base}->{$id}->{create_time} = $issues->date_prepare($issues->{issues_base}->{$id}->{date_time});
      # sprintf("%02d:%02d:%02d %02d/%02d/%4d", $hour, $min, $sec, $mday, $mon + 1, $year + 1900);
    push @{$self->{vars}->{issues}}, $issues->{issues_base}->{$id};
  }

  # $system->dump($self->{vars}->{issues});

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
