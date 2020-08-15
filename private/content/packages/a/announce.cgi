use strict;
use FWork::System;
use Announces;
use Issues;
use Structure;
use utf8;
use Encode;

sub announce {
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

  my $anobj = Announces->new();
  my $announces = $anobj->get_announces($in->query('issue_id'));

  $structure->{__main}->{name} = Encode::encode("utf8", 'Главный анонс');
  $structure->{__main_lenta}->{name} = Encode::encode("utf8", 'Главная лента');

  foreach my $aid (sort {$announces->{$b}->{ctime} cmp $announces->{$a}->{ctime}} keys %$announces) {
    $announces->{$aid}->{aid} = $aid;
    $announces->{$aid}->{create_time} = $anobj->date_prepare($announces->{$aid}->{ctime});
    $announces->{$aid}->{t_path} = $structure->{$announces->{$aid}->{path}}->{name};
    $announces->{$aid}->{t_item} = $structure->{$announces->{$aid}->{path}}->{items}->{$announces->{$aid}->{item}}->{name} if $announces->{$aid}->{item};
    push @{$self->{vars}->{anns}}, $announces->{$aid};
  }

    # $system->dump($self->{vars}->{anns});

  my $content = $self->_template()->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
