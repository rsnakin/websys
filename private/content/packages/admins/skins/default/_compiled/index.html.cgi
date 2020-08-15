# Generated: Sun Dec 18 16:42:03 2016
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;border:1px dotted #000">

<table width="100%">
';my $var=$v->{'envs'};if (ref $var eq 'ARRAY') {my $saved=$v->{'e'};$v->{'e'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'e'}=$element;push @p,'<tr>
<td style="border-bottom:1px dotted #ccc;padding:5px;"><b>';push @p,$v->{'e'}->{'name'};push @p,'</b></td>
<td style="border-bottom:1px dotted #ccc;border-left:1px dotted #ccc;padding:5px;">';push @p,$v->{'e'}->{'value'};push @p,'</td>
</tr>
';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'e'}=$saved;}push @p,'</table>
</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
