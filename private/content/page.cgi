use strict;
use FWork::System;
use utf8;
use Structure;
use Issues;

sub page {
  my $self = shift;
  my $in = $system->in;

  # $system->dump($in);

  if(not $in->query('tail_id')) {
    $self->{vars}->{page} = '/' . $in->query('text_id');
  } else {
    $self->{vars}->{page} = '/' . $in->query('tail_id');
  }
  my $structure = Structure->new();
  $self->{vars}->{menu} = $structure->get_structure();
  my $type = $structure->get_type($in->query('tail_id'), $in->query('text_id'));

  if($type eq 'issue') {
    my $issues = Issues->new();;
    my $issue;
    my $issue_id;
    foreach my $iid (sort {$issues->{issues_base}->{$a}->{date_time} <=> $issues->{issues_base}->{$b}->{date_time}} keys %{$issues->{issues_base}}) {
      if($in->query('tail_id') eq $issues->{issues_base}->{$iid}->{path} 
        and $in->query('text_id') eq $issues->{issues_base}->{$iid}->{item}) {
        $issue = $issues->{issues_base}->{$iid};
        $issue_id = $iid;
      }
      if($in->query('text_id') eq $issues->{issues_base}->{$iid}->{path} 
        and not $in->query('tail_id')) {
        $issue = $issues->{issues_base}->{$iid};
        $issue_id = $iid;
      }
    }
    # $system->dump($issues->{issues_base});
    # my $issue = $issues->{issues_base}->{$in->query('issue_id')};
    $issue->{body} = $issues->get_issue($issue_id);
    $issue->{t_path} = $structure->{$issue->{path}}->{name};
    $issue->{t_item} = $structure->{$issue->{path}}->{items}->{$issue->{item}}->{name} if $issue->{item};
    $issue->{date_time} = $issues->date_prepare($issue->{date_time});
    $issue->{body} = $issues->render_body($issue->{body});
    $self->{vars}->{i} = $issue;    
  }

  $type = '404' if not $type;
  my $content = $self->_template($type . '.html')->parse($self->{vars});
  $system->out->say($content);
  $system->stop;
}

1;
