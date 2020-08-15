# Generated: Wed Jan 23 18:40:35 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'
<!DOCTYPE html>
<html lang="ru">
    ';push @p,$s->{pkg}->_template('inc/head.html')->parse($v);push @p,'
    ';push @p,$s->{pkg}->_template('inc/style.html')->parse($v);push @p,'
    <body>

    <!-- Fixed navbar -->
    ';push @p,$s->{pkg}->_template('inc/menu.html')->parse($v);push @p,'

    <!-- Begin page content -->
    <div class="container">
        <h4>&nbsp;</h4>
        <div class="blog-header">
          <h3 class="blog-title">Страница не найдена, уточните адрес!</h3>
          <p class="lead blog-description"><br><b>Совет:</b> перейдите на <a href="/">главную страницу</a> или выполните поиск.</p>
        </div>  
      </div>
    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/jquery.min.js"></script>
    <script>window.jQuery || document.write(\'<script src="/js/jquery.min.js"><\\/script>\')</script>
    <script src="/js/bootstrap.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="/js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;
