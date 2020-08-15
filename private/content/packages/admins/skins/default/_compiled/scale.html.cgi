# Generated: Sun Dec 18 16:28:11 2016
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;height:1000px;">
Hello!
</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
