# Generated: Mon Oct 16 01:48:51 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;border:1px dotted #000">
<form method="post">
<input type="hidden" name="action" value="add_models">
<input type="hidden" name="pkg" value="content:admins">
<table width="100%">
  <tr>
    <td valign="top" align="center" style="border-top:1px dotted #CCC" width="33%">
      Категории
      <select name="categories" multiple="multiple" style="width:100%;height:100px">
        ';my $var=$v->{'cats'};if (ref $var eq 'ARRAY') {my $saved=$v->{'c'};$v->{'c'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'c'}=$element;push @p,'<option value="';push @p,$v->{'c'}->{'category_id'};push @p,'"';if(($in->query('categories') eq $v->{'c'}->{'category_id'})){push @p,' selected';}push @p,'>';push @p,$v->{'c'}->{'category_name'};push @p,'</option>';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'c'}=$saved;}push @p,'
      </select>
    </td>
    <td valign="top" align="center" style="border-top:1px dotted #CCC" width="33%">
      Производители
      <select name="brands" multiple="multiple" style="width:100%;height:100px">
        ';my $var=$v->{'brands'};if (ref $var eq 'ARRAY') {my $saved=$v->{'b'};$v->{'b'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'b'}=$element;push @p,'<option value=';push @p,$v->{'b'}->{'brand_id'};if(($in->query('brands') eq $v->{'b'}->{'brand_id'})){push @p,' selected';}push @p,'>';push @p,$v->{'b'}->{'brand_name'};push @p,'</option>';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'b'}=$saved;}push @p,'
      </select>
    </td>
    <td valign="top" align="center" style="border-top:1px dotted #CCC" width="33%">
      Марки
      <select name="marks" multiple="multiple" style="width:100%;height:100px">
        ';my $var=$v->{'marks'};if (ref $var eq 'ARRAY') {my $saved=$v->{'m'};$v->{'m'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'m'}=$element;push @p,'<option value=';push @p,$v->{'m'}->{'mark_id'};if(($in->query('marks') eq $v->{'m'}->{'mark_id'})){push @p,' selected';}push @p,'>';push @p,$v->{'m'}->{'mark_name'};push @p,'</option>';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'m'}=$saved;}push @p,'
      </select>
    </td>
  </tr>
  <tr>
    <td align="right">
    Название:
    </td>
    <td colspan="2">
    <input type="text" name="model_name" style="width:100%">
    </td>
  </tr>
  <tr>
    <td align="right">
    Год выпуска:
    </td>
    <td colspan="2">
    <input type="text" name="model_year" style="width:100%">
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">
    Общие данные об автомобиле:
    </td>
    <td colspan="2">
    <textarea name="model_common" style="width:100%;height:100px;resize:none;">';push @p,$v->{'model'}->{'model_common'};push @p,'</textarea>
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">
    Характеристика автомобиля:
    </td>
    <td colspan="2">
    <textarea name="model_char" style="width:100%;height:100px;resize:none;">';push @p,$v->{'model'}->{'model_char'};push @p,'</textarea>
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">
    Описание модели:
    </td>
    <td colspan="2">
    <textarea name="model_desc" style="width:100%;height:100px;resize:none;">';push @p,$v->{'model'}->{'model_desc'};push @p,'</textarea>
    </td>
  </tr>
  <tr>
    <td align="right">
    </td>
    <td colspan="2">
    <input type="submit" name="add" value="Добавить">
    </td>
  </tr>
</table>
</form>
</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,'<script type="text/javascript">

</script>
';push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
