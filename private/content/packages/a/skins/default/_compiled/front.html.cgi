# Generated: Sun Feb 10 19:26:40 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<!DOCTYPE html>
<html lang="ru">
  ';push @p,$s->{pkg}->_template('inc/head.html')->parse($v);push @p,'
  ';push @p,$s->{pkg}->_template('inc/style.html')->parse($v);push @p,'
  <body>

    <!-- Fixed navbar -->
    ';push @p,$s->{pkg}->_template('inc/menu.html')->parse($v);push @p,'
    <div class="container">
      <!-- <div class="row">
        <div class="col-md-4"><b>Главная</b> <a class="btn btn-default editButton" data-toggle="modal" data-target="#addTopic" id="addTopicButton">Добавить раздел</a><a class="btn btn-default editButton" id="saveTopicButton">Сохранить</a></div>
        <div class="" id="structureDiv"></div>
      </div> -->
    </div>

    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/jquery.min.js"></script>
    <script>window.jQuery || document.write(\'<script src="/js/jquery.min.js"><\\/script>\')</script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/jquery.json.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="/js/ie10-viewport-bug-workaround.js"></script>
    <script type="text/javascript">

    </script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;
