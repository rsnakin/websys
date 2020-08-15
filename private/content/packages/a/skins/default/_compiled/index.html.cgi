# Generated: Thu Jan 24 00:30:22 2019
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
      <div class="row">
        <div class="col-md-4"><b>Главная</b> <a class="btn btn-default editButton" data-toggle="modal" data-target="#addTopic" id="addTopicButton">Добавить раздел</a><a class="btn btn-default editButton" id="saveTopicButton">Сохранить</a></div>
        <div class="" id="structureDiv"></div>
      </div>
    </div>

    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

<!-- Модаль -->
<div class="modal fade" id="addTopic" tabindex="-1" role="dialog" aria-labelledby="ddTopicLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel"></h4>
      </div>
      <div class="modal-body">
        <p><input type="text" id="bName" name="bName" class="form-control" value="" placeholder="Название раздела" required autofocus></p>
        <p><input type="text" id="bPath" name="bPath" class="form-control" value="" placeholder="Путь к разделу" required autofocus></p>
        <p>
          <select class="form-control" name="bType" id="bType">
            <option value="" selected>Тип</option>
            <option value="1">Статья</option>
            <option value="2">Сетка</option>
            <option value="3">Узел</option>
          </select>
        </p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" id="closeDialog">Закрыть</button>
        <button type="button" class="btn btn-primary" id="doTopic"></button>
      </div>
    </div>
  </div>
</div>

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
      var sStructure = {};
      var test;
      var types = {
        1: \'Статья\',
        2: \'Сетка\',
        3: \'Узел\'
      };
      loadStructure();
      $(\'#saveTopicButton\').click(function(){
        $.post(
          \'/cgi-bin/index.cgi\', {
            pkg: \'content:a\',
            action: \'save_structure\',
            structure: $.toJSON(sStructure)
          },
          function(data, textStatus){
            if(!data || !$.evalJSON(data) || $.evalJSON(data).status != \'ok\') {
              alert(\'Error!\');
            } else {
              $(\'#info\').html(\'Структура успешно сохранена!\');
              setTimeout(function(){ $(\'#info\').html(\'\'); }, 800);
            }
          }
        );
      });
      var timerId = setInterval(function() {
        $(\'#saveTopicButton\').trigger(\'click\');
      }, 60000);
      var timerId1 = setInterval(function() {
        $(\'#info\').append(\'_\');
      }, 1000);
      $(\'#addTopicButton\').click(function(){
        $(\'#doTopic\').unbind(\'click\');
        $(\'#myModalLabel\').html(\'Добавить раздел\');
        $(\'#bName\').val(\'\');
        $(\'#bPath\').val(\'\');
        $(\'#bType\').val(\'\');
        $(\'#doTopic\').html(\'Добавить\');
        $(\'#doTopic\').click(function(){
          if(!$(\'#bName\').val() || !$(\'#bType\').val() || !$(\'#bPath\').val()) { alert(\'Заполните все поля!\'); return; }
          for (var topic in sStructure) {
            sStructure[topic].sort_id ++; 
          }
          sStructure[$(\'#bPath\').val()] = { name: $(\'#bName\').val(), type: $(\'#bType\').val(), sort_id: 1 };
          showStructure();
          $(\'#closeDialog\').trigger(\'click\');
        });
      });
      function showStructure() {
        var content = \'<table>\';
        for (var i = 1; i < 100; i++) {
          var existTopic = false;
          for (var topic in sStructure) {
            if(sStructure[topic].sort_id == i) {
              content += \'<tr style="border-top:1px solid #eee;"><td valign="top" colspan="2">\' +
              \'<b>\' + sStructure[topic].name + \'</b><p class="node">\' + types[sStructure[topic].type] + \'<br>\' +
              \'/\' + topic + \'</p></td><td colspan="2" valign="top"><span class="glyphicon glyphicon-menu-up mover" \' +
              \'movetopic="\' + topic + \'" move="up"></span><span class="glyphicon glyphicon-menu-down mover" \' +
              \'movetopic="\' + topic + \'" move="down"></span><a class="btn btn-default editButton editTopicButton" data-toggle="modal" data-target="#addTopic" \' +
              \'edittopic="\' + topic + \'">Редактировать</a><a class="btn btn-default editButton deleteTopicButton" \' +
              \'deletetopic="\' + topic + \'">Удалить</a>\';
              if(sStructure[topic].type == 3) {
                content += \'<a class="btn btn-default editButton addItemButton" data-toggle="modal" data-target="#addTopic" \' +
                \'edittopic="\' + topic + \'">Добавить подраздел</a>\';
              }
              content += \'</td></tr>\';
              if(sStructure[topic].items) {
                var existItem = false;
                for (var n = 1; n < 100; n++) {
                  for (var itm in sStructure[topic].items) {
                    if(sStructure[topic].items[itm].sort_id == n) {
                      content += \'<tr><td style="background: #f7f7f7;">&nbsp;&nbsp;&nbsp;&nbsp;</td><td valign="top" style="padding-left:5px;">\' +
                      \'<b>\' + sStructure[topic].items[itm].name + \'</b><p class="node">\' + types[sStructure[topic].items[itm].type] + \'<br>/\' + topic +
                      \'/\' + itm + \'</p></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td valign="top"><span class="glyphicon glyphicon-menu-up moverItem" \' +
                      \'moveitem="\' + itm + \'" move="up" movetopic="\' + topic + \'"></span><span class="glyphicon glyphicon-menu-down moverItem" \' +
                      \'moveitem="\' + itm + \'" move="down" movetopic="\' + topic + \'"></span><a class="btn btn-default editButton editItemButton" data-toggle="modal" data-target="#addTopic" \' +
                      \'edititem="\' + itm + \'" edittopic="\' + topic + \'">Редактировать</a><a class="btn btn-default editButton deleteItemButton" \' +
                      \'deleteitem="\' + itm + \'" deletetopic="\' + topic + \'">Удалить</a>\';
                      content += \'</td></tr>\';
                      existItem = true;
                    }
                  }
                  if(!existItem) break;
                }
              }
              existTopic = true;
            }
          }
          if(!existTopic) break;
        }
        content += \'</table>\';
        $(\'#structureDiv\').html(content);
        $(\'.editItemButton\').unbind(\'click\');
        $(\'.deleteItemButton\').unbind(\'click\');
        $(\'.addItemButton\').unbind(\'click\');
        $(\'.mover\').unbind(\'click\');
        $(\'.moverItem\').unbind(\'click\');
        $(\'.editTopicButton\').unbind(\'click\');
        $(\'.deleteTopicButton\').unbind(\'click\');
        $(\'.moverItem\').click(function(){
          var topic = $(this).attr(\'movetopic\');
          var item = $(this).attr(\'moveitem\');
          var move = $(this).attr(\'move\');
          // alert(topic + \' \' + item + \' \' + move);
          // return;
          var sort_id = sStructure[topic].items[item].sort_id;
          if(move == \'up\') {sort_id --;} else {sort_id ++;}
          for (var itm in sStructure[topic].items) {
            if(sStructure[topic].items[itm].sort_id == sort_id) {
              sStructure[topic].items[itm].sort_id = sStructure[topic].items[item].sort_id;
              sStructure[topic].items[item].sort_id = sort_id;
            }
          }
          showStructure();

        });
        $(\'.editItemButton\').click(function(){
          var topic = $(this).attr(\'edittopic\');
          var item = $(this).attr(\'edititem\');
          $(\'#myModalLabel\').html(\'Редактировать подраздел "\' + sStructure[topic].items[item].name + \'"\');
          $(\'#doTopic\').html(\'Сохранить\');
          $(\'#bName\').val(sStructure[topic].items[item].name);
          $(\'#bPath\').val(item);
          $(\'#bType\').val(sStructure[topic].items[item].type);
          $(\'#doTopic\').unbind(\'click\');
          $(\'#doTopic\').click(function(){
            if(!$(\'#bName\').val() || !$(\'#bType\').val() || !$(\'#bPath\').val()) { alert(\'Заполните все поля!\'); return; }
            var sort_id = sStructure[topic].items[item].sort_id;
            delete sStructure[topic].items[item];
            sStructure[topic].items[$(\'#bPath\').val()] = { name: $(\'#bName\').val(), type: $(\'#bType\').val(), sort_id: sort_id };
            showStructure();
            $(\'#closeDialog\').trigger(\'click\');
          });
          // alert(topic + \' \' + item);
        });
        $(\'.deleteItemButton\').click(function(){
          var topic = $(this).attr(\'deletetopic\');
          var item = $(this).attr(\'deleteitem\');
          if(confirm(\'Удалить "\' + sStructure[topic].items[item].name + \'"?\')) {
            var sort_id = sStructure[topic].items[item].sort_id;
            for (var itm in sStructure[topic].items) {
              if(sStructure[topic].items[itm].sort_id > sort_id) {
                sStructure[topic].items[itm].sort_id --;
              }
            }
            delete sStructure[topic].items[item];
          }
          showStructure();
        });
        $(\'.addItemButton\').click(function(){
          var topic = $(this).attr(\'edittopic\');
          $(\'#myModalLabel\').html(\'Добавить подраздел в "\' + sStructure[topic].name + \'"\');
          $(\'#doTopic\').html(\'Добавить\');
          $(\'#bName\').val(\'\');
          $(\'#bPath\').val(\'\');
          $(\'#bType\').val(\'\');
          $(\'#doTopic\').unbind(\'click\');
          $(\'#doTopic\').click(function(){
            if(!$(\'#bName\').val() || !$(\'#bType\').val() || !$(\'#bPath\').val()) { alert(\'Заполните все поля!\'); return; }
            if(!sStructure[topic][\'items\']) { sStructure[topic][\'items\'] = {}; }
            for (var itm in sStructure[topic].items) {
              sStructure[topic].items[itm].sort_id ++;
            }
            sStructure[topic][\'items\'][$(\'#bPath\').val()] = { name: $(\'#bName\').val(), type: $(\'#bType\').val(), sort_id: 1 };
            showStructure();
            $(\'#closeDialog\').trigger(\'click\');
          });
          // alert(topic);
        });
        $(\'.mover\').click(function(){
          var path = $(this).attr(\'movetopic\');
          var move = $(this).attr(\'move\');
          var sort_id = sStructure[path].sort_id;
          if(move == \'up\') {sort_id --;} else {sort_id ++;}
          for (var topic in sStructure) {
            if(sStructure[topic].sort_id == sort_id) {
              sStructure[topic].sort_id = sStructure[path].sort_id;
              sStructure[path].sort_id = sort_id;
            }
          }
          showStructure();
          // alert(path + \' \' + move + \' \' + sort_id);
        });
        $(\'.deleteTopicButton\').click(function(){
          var path = $(this).attr(\'deletetopic\');
          if(confirm(\'Удалить "\' + sStructure[path].name + \'"?\')) {
            var sort_id = sStructure[path].sort_id;
            for (var topic in sStructure) {
              if(sStructure[topic].sort_id > sort_id) {
                sStructure[topic].sort_id --;
              }
            }
            delete sStructure[path];
          }
          showStructure();
        });
        $(\'.editTopicButton\').click(function(){
          var path = $(this).attr(\'edittopic\');
          $(\'#myModalLabel\').html(\'Редактировать раздел\');
          $(\'#bName\').val(sStructure[path].name);
          $(\'#bPath\').val(path);
          $(\'#bType\').val(sStructure[path].type);
          $(\'#doTopic\').unbind(\'click\');
          $(\'#doTopic\').html(\'Сохранить\');
          $(\'#doTopic\').click(function(){
            if(!$(\'#bName\').val() || !$(\'#bType\').val() || !$(\'#bPath\').val()) { alert(\'Заполните все поля!\'); return; }
            var sort_id = sStructure[path].sort_id;
            var items = sStructure[path].items;
            delete sStructure[path];
            sStructure[$(\'#bPath\').val()] = { name: $(\'#bName\').val(), type: $(\'#bType\').val(), sort_id: sort_id, items: items };
            showStructure();
            $(\'#closeDialog\').trigger(\'click\');
          });
        });
      }
      function loadStructure() {
        $.post(
          \'/cgi-bin/index.cgi\', {
            pkg: \'content:a\',
            action: \'load_structure\'
          },
          function(data, textStatus){
            if(!data || !$.evalJSON(data)) {
              alert(\'Error!\');
            } else {
              sStructure = $.evalJSON(data);
              showStructure();
            }
          }
        );
      }
      </script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;