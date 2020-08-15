# Generated: Wed Jan 23 18:33:04 2019
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
    <div class="jumbotron" style="background:#fff">
        <div class="container">
          <h4>&nbsp;</h4>
          <h3 class="blog-title">Сетка</h3>
          <h4>&nbsp;</h4>
          <p style="font-size: 16px;">Немцы переселялись из Европы в Россию на протяжении столетий. В их слободах веками сохранялась германская культура и язык. Теперь их этнических потомки, живущие в России и СНГ, вправе получить статус <b>Sp&auml;taussiedler</b> &ndash; &laquo;поздний переселенец&raquo;. Положительное решение позволяет переехать в Германию и оформить паспорт этой страны.</p>
          <p align="right"><a class="btn btn-default myButton" href="/issue_test.html" role="button">Подробнее &raquo;</a></p>
        </div>
    </div>
    <div class="nurTitle">Сетка</div>
    <div class="container">
        <!-- Example row of columns -->
        <div class="row">
          <div class="col-md-4 borda">
            <h4>Германия готова к «жесткому» выходу Великобритании из состава ЕС</h4>
            <p>Германия хочет, чтобы Лондон и Брюссель заключили сделку по Brexit, заявил министр экономики ФРГ Петер Альтмайер.</p>
            <p align="right"><a class="btn btn-default myButton" href="#" role="button">Подробнее &raquo;</a></p>
          </div>
          <div class="col-md-4 borda">
            <h4>Русская Германия (Германия): школьник преподал урок</h4>
            <p>Наступивший год в Германии начался с крупного скандала в области информационных технологий: в свободном доступе в интернете оказались личные данные сотен немецких политиков, знаменитостей, известных сетевых деятелей.</p>
            <p align="right"><a class="btn btn-default myButton" href="#" role="button">Подробнее &raquo;</a></p>
          </div>
          <div class="col-md-4 borda">
            <h4>В Германии избрали нового лидера ХСС</h4>
            <p>Премьер-министра федеральной земли Бавария Маркуса Зедера избрали председателем Христианско-социального союза (ХСС). </p>
            <p align="right"><a class="btn btn-default myButton" href="#" role="button">Подробнее &raquo;</a></p>
          </div>
        </div>
        <div class="row">
          <div class="col-md-4 borda">
            <h4>Германия может остаться без 5G</h4>
            <p>Немецкие власти по сигналу Вашингтона могут закрыть для Huawei рынок связи пятого поколения.</p>
            <p align="right"><a class="btn btn-default myButton" href="#" role="button">Подробнее &raquo;</a></p>
          </div>
          <div class="col-md-4 borda">
            <h4>Германия изучит последствия слияния Deutsche Bank и Commerzbank</h4>
            <p>Министерство финансов Германии запросило у Федерального ведомства по надзору за финансовым сектором (BaFin) результаты анализа возможных последствий слияния двух крупнейших коммерческих банков страны, Deutsche Bank AG (DB) и Commerzbank AG.</p>
            <p align="right"><a class="btn btn-default myButton" href="#" role="button">Подробнее &raquo;</a></p>
          </div>
          <div class="col-md-4 borda">
            <h4>Wirtschaftswoche (Германия): дешевле, чем «Альди» и «Лидл»</h4>
            <p>Российский дискаунтер из Сибири вторгается на немецкий продовольственный рынок, пишет журнал «Виртшафтсвохе». Он имеет в виду российскую компанию «Торгсервис», бросившую вызов таким признанным немецким гигантам, как «Альди» и «Лидл». </p>
            <p align="right"><a class="btn btn-default myButton" href="#" role="button">Подробнее &raquo;</a></p>
          </div>
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
