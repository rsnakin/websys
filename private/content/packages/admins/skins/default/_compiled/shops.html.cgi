# Generated: Thu Dec 22 15:37:49 2016
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;border:1px dotted #000">
<form name="nshop" action="/cgi-bin/index.cgi" method="post">
<input type="hidden" name="pkg" value="content:admins">
<input type="hidden" name="action" value="shops">
<table width="100%" style="padding:1px">
  <tr>
    <td colspan="4" style="padding:0px"><h3>Добавить магазин<h3></td>
  </tr>
  <tr>
    <td width="30%" style="padding-left:10px;">Название</td>
    <td width="30%" style="padding-left:10px">URL</td>
    <td width="20%" style="padding-left:10px">ID</td>
    <td width="10%" style="padding-left:10px"></td>
  </tr>
  <tr>
    <td width="30%" style="padding:10px"><input type="text" value="';push @p,$in->query('shop_name');push @p,'" name="shop_name" style="width:100%"></td>
    <td width="30%" style="padding:10px"><input type="text" value="';push @p,$in->query('shop_url');push @p,'" name="shop_url" style="width:100%"></td>
    <td width="20%" style="padding:10px"><input type="text" value="';push @p,$in->query('shop_id');push @p,'" name="shop_id" style="width:100%"></td>
    <td width="10%" style="padding:10px"><input type="submit" value="сохранить" name="save"></td>
  </tr>
</table>
</form>
</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
