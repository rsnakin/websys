use strict;
use FWork::System;
use Issues;
use Structure;
use utf8;

sub edit_issue {
  my $self = shift;
  my $in = $system->in;

  $self->{vars}->{page} = 'issues';

  my $structure = Structure->new()->{jstructure};

  my $issues = Issues->new();
  my $issue = $issues->{issues_base}->{$in->query('issue_id')};
  $issue->{body} = $issues->get_issue($in->query('issue_id'));
  $issue->{t_path} = $structure->{$issue->{path}}->{name};
  $issue->{t_item} = $structure->{$issue->{path}}->{items}->{$issue->{item}}->{name} if $issue->{item};
  $issue->{date_time} = $issues->date_prepare($issue->{date_time});
  $self->{vars}->{i} = $issue;

  $self->{vars}->{img} = $issues->get_issue_imgs($in->query('issue_id'));
  # $system->dump($self->{vars}->{img});

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
