# Generated: Fri May  1 22:33:06 2020
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
';push @p,$s->{pkg}->_template('inc/menu.html')->parse($v);push @p,'    <div class="container" style="padding-top:60px;">
        ';push @p,$s->{pkg}->_template('inc/carousel.html')->parse($v);push @p,'
    </div>
    
        <div class="container" style="padding-top:0px;">
          <h1 class="blog-title"><b>';push @p,$v->{'main_announce'}->{'name'};push @p,'</b></h1>
          <h4>&nbsp;</h4>
          <p style="font-size: 16px;">';push @p,$v->{'main_announce'}->{'body'};push @p,'</p>
          <p align="right"><a href="';push @p,$v->{'main_announce'}->{'link'};push @p,'">Подробнее &raquo;</a></p>
        </div>
    <h2 class="nurTitle">Полезная информация</h2>
    <div class="container">
        <!-- Example row of columns -->
        <div class="row">
          ';my $var=$v->{'announces'};if (ref $var eq 'ARRAY') {my $saved=$v->{'a'};$v->{'a'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'a'}=$element;push @p,'
          <div class="col-md-4 borda">
            <h3><a href="';push @p,$v->{'a'}->{'link'};push @p,'">';push @p,$v->{'a'}->{'name'};push @p,'</a></h3>
            <p><a href="';push @p,$v->{'a'}->{'link'};push @p,'" class="alink">';push @p,$v->{'a'}->{'body'};push @p,'</a></p>
            <!-- <p align="right"><a href="';push @p,$v->{'a'}->{'link'};push @p,'">Подробнее &raquo;</a></p> -->
          </div>
          ';if((true($v->{'a'}->{'next_line'}))){push @p,'
          </div>
          <div class="row">
          ';}push @p,'
          ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'a'}=$saved;}push @p,'
        </div>
    </div>
    <div style="padding: 40px;"></div>
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
    <script type="text/javascript">
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
      $(\'.carouselImage\').each(function(){
        if($(this).innerHeight() > 0) {
          var cHeight = $(this).innerHeight();
          // alert(cHeight);
          $(\'.carousel-link\').css(\'font-size\', (cHeight / 8) + \'px\');
        }
      });
    </script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;
