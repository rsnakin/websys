# Generated: Wed Jun 17 19:54:42 2020
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
  
      <div class="row">

        <div class="col-sm-12 blog-main">
          <div class="blog-header">
            <h1 class="blog-title"><b>';push @p,$v->{'i'}->{'name'};push @p,'</b></h1>
            <p class="blog-post-meta"></p>
            <p class="blog-post-meta">';push @p,$v->{'i'}->{'date_time'};push @p,'</p>
          </div>
    
          <div class="blog-post">
            ';push @p,$v->{'i'}->{'body'};push @p,'<p>&nbsp;</p>
          </div><!-- /.blog-post -->
        </div><!-- /.blog-main -->

        

      </div><!-- /.row -->
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
        <script src="/js/jquery.json.min.js"></script>
    <script src="/js/cookies.js"></script>
    <script src="/js/debug.js"></script>
    <script src="/js/dtools.js"></script>   
<!--     <script src="/js/menu.js"></script> -->
    <script src="/js/forum/reg_modal.js"></script>
    <script src="/js/forum/login.js"></script>
    <script src="/js/highlight/highlight.pack.js"></script>
    <script type="text/javascript">
      hljs.initHighlightingOnLoad();

        $(\'.codeBlock\').click(function(){
            var pid = $(this).attr(\'pid\');
            if($(\'#\' + pid).css(\'display\') == \'none\') {
                $(\'#\' + pid).css(\'display\', \'block\');
            } else {
                $(\'#\' + pid).css(\'display\', \'none\');
            }
        });
      
      /*
      var pageMenu = new menu();

      var menuTray = function(tray) {
        tray.object.unbind(\'click\');
        tray.update(\'12\');
        tray.object.click(function(){
          //appendInfo(\'click!!\');
          tray.hide();
          setTimeout(function(){tray.update(parseInt(Math.random() * 100));}, 2000);
        });
      };

      pageMenu.userTrayAction(menuTray);
      pageMenu.start();
      */
      // var cHeight;
  </script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;
