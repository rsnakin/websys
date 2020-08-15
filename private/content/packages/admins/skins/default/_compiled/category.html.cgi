# Generated: Fri Oct 13 17:10:25 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;border:1px dotted #000">
<table width="100%">
<tr>
  <td valign="top" style="border-top:1px dotted #CCC">
    <b>Добавить категорию</b>
  </td>
  <td style="border:1px dotted #CCC"><div>
      <form name="cat_new" method="post" action="/cgi-bin/index.cgi">
      <input type="hidden" name="action" value="category">
      <input type="hidden" name="pkg" value="content:admins">
      <input type="text" value="" name="category_name" style="width:99%">
      <input type="submit" name="add" value="добавить">
      </form>
  </div></td>
</tr>
';my $var=$v->{'cats'};if (ref $var eq 'ARRAY') {my $saved=$v->{'c'};$v->{'c'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'c'}=$element;push @p,'<tr>
  <td valign="top" style="border-top:1px dotted #CCC">
    <b>';push @p,$v->{'c'}->{'category_name'};push @p,'</b> (';push @p,$v->{'c'}->{'text_id'};push @p,')
    <span class="links" cat_id="cat_';push @p,$v->{'c'}->{'category_id'};push @p,'" id="click_';push @p,$v->{'c'}->{'category_id'};push @p,'" style="cursor:pointer">[редактировать]</span>
  </td>
  <td style="border:1px dotted #CCC"><div style="display:none" id="cat_';push @p,$v->{'c'}->{'category_id'};push @p,'">
      <form name="cat_';push @p,$v->{'c'}->{'category_id'};push @p,'" method="post" action="/cgi-bin/index.cgi">
      <input type="hidden" name="action" value="category">
      <input type="hidden" name="pkg" value="content:admins">
      <input type="hidden" name="category_id" value="';push @p,$v->{'c'}->{'category_id'};push @p,'">
      <input type="text" value="';push @p,$v->{'c'}->{'category_name'};push @p,'" name="category_name" style="width:99%">
      <input type="reset" value="отменить"><input type="submit" name="save" value="сохранить"><input type="submit" catid="';push @p,$v->{'c'}->{'category_id'};push @p,'" class="delete_button" name="delete" value ="удалить">
      </form>
  </div>
  </td>
</tr>
';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'c'}=$saved;}push @p,'</table>

</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,'<script type="text/javascript">

  $(\'.delete_button\').click(function(){
    return(confirm(\'Удалить \' + $(this).attr(\'catid\') + \'?\'));
  });

  $(\'.links\').click(function(){
    var cat_id = $(this).attr(\'cat_id\');
    var status = $(this).attr(\'status\');
    if(!status) {
      $(\'#\' + cat_id).css(\'display\', \'block\');
      $(\'#__\' + cat_id).css(\'display\', \'none\');
      $(this).html(\'[скрыть]\');
      $(this).attr(\'status\', \'o\');
    }
    if(status) {
      $(\'#\' + cat_id).css(\'display\', \'none\');
      $(\'#__\' + cat_id).css(\'display\', \'block\');
      $(this).html(\'[редактировать]\');
      $(this).attr(\'status\', \'\');
    }
  });

//   ';if((true($v->{'trigger'}))){push @p,'//     $(\'#click_';push @p,$v->{'trigger'};push @p,'\').trigger(\'click\');
//     location.hash = "#click_';push @p,$v->{'trigger'};push @p,'";
//   ';}push @p,'  
</script>
';push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
