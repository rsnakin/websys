# Generated: Thu Oct 19 18:27:24 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<div class="uk-block uk-padding-remove">
<div class="uk-grid">
';my $var=$v->{'bgs'};if (ref $var eq 'ARRAY') {my $saved=$v->{'i'};$v->{'i'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'i'}=$element;push @p,'<div class="uk-width-2-10" style="padding-bottom:5px">
  <img src="';push @p,$v->{'base_url'};push @p,'/';push @p,$v->{'i'}->{'bg_name'};push @p,'.jpg?v=';push @p,$v->{'rand'};push @p,'" class="bgsclick" oo="';push @p,$v->{'i'}->{'bg_id'};push @p,'">
</div>
';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'i'}=$saved;}push @p,'</div>
</div>
';
$s->{parsed}=join('',@p);
};
1;
