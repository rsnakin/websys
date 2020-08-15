# Generated: Sun Dec 18 16:18:23 2016
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<script type="text/javascript">

var lbody = $(\'body\').height();
var wheight = $(window).height();

if(lbody < wheight) {
        $(\'body\').css(\'height\', wheight + \'px\');
}
</script>
';
$s->{parsed}=join('',@p);
};
1;
