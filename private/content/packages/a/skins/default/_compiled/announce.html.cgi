# Generated: Wed Feb 13 13:42:51 2019
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
    
    <div class="container" style="padding-top:20px;">
        <div class="blog-header">
          <h3 class="blog-title">Анонсы "';push @p,$v->{'i'}->{'name'};push @p,'"</h3>
          <p><span class="glyphicon glyphicon-leaf"></span> &raquo; ';push @p,$v->{'i'}->{'t_path'};push @p,' &raquo; ';push @p,$v->{'i'}->{'t_item'};push @p,'</p>
          <hr>
        </div>
        <table width="100%">
          <tr>
            <td class="issue_table_header" width="50%">Название</td>
            <td class="issue_table_header" width="20%">Дата</td>
            <td class="issue_table_header" width="10%">Раздел</td>
            <td class="issue_table_header" width="10%">Подраздел</td>
            <td class="issue_table_header" width="5%"><a class="" data-toggle="modal"
              data-target="#addAnn" id="addAnnButton" style="cursor:pointer;"><span 
              class="glyphicon glyphicon-file" aria-hidden="true"></span></a></td>
          </tr>
          ';my $var=$v->{'anns'};if (ref $var eq 'ARRAY') {my $saved=$v->{'i'};$v->{'i'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'i'}=$element;push @p,'
          <tr>
            <td class="issue_table" width="50%"><a class="editAnnButton" data-toggle="modal"
              data-target="#addAnn" style="cursor:pointer;" aname="';push @p,$v->{'i'}->{'name'};push @p,'"
              aid="';push @p,$v->{'i'}->{'aid'};push @p,'" abody="';push @p,$v->{'i'}->{'body'};push @p,'" path="';push @p,$v->{'i'}->{'path'};push @p,'" item="';push @p,$v->{'i'}->{'item'};push @p,'" ctime="';push @p,$v->{'i'}->{'ctime'};push @p,'">';push @p,$v->{'i'}->{'name'};push @p,'</a></td>
            <td class="issue_table" width="20%">';push @p,$v->{'i'}->{'create_time'};push @p,'</td>
            <td class="issue_table" width="10%">';push @p,$v->{'i'}->{'t_path'};push @p,'</td>
            <td class="issue_table" width="10%">';push @p,$v->{'i'}->{'t_item'};push @p,'</td>
            <td class="issue_table" width="5%"><a class="deleteAnnounce" aname="';push @p,$v->{'i'}->{'name'};push @p,'" aid="';push @p,$v->{'i'}->{'aid'};push @p,'" style="cursor:pointer;"><span 
              class="glyphicon glyphicon-remove-sign"></span></a></td>
          </tr>
          ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'i'}=$saved;}push @p,'
        </table>
      </div>

    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'
    <!-- Модаль -->
    <div class="modal fade" id="addAnn" tabindex="-1" role="dialog" aria-labelledby="ddTopicLabel">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 class="modal-title" id="myModalLabel">Добавить анонс</h4>
            </div>
            <div class="modal-body">
              <p><input type="text" id="aName" name="aName" class="form-control" value="" placeholder="Название анонса" required autofocus></p>
              <p><textarea class="form-control" placeholder="Текст анонса" id="aBody" style="height: 250px;"></textarea></p>
              <p>
                <select class="form-control" name="bBranche" id="branche">
                </select>
              </p>
              <p>
                <select class="form-control" name="bsBranche" id="sbranche" disabled>
                </select>
              </p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal" id="closeDialog">Закрыть</button>
              <button type="button" class="btn btn-primary" id="doTopic" style="display: none;">Добавить</button>
              <button type="button" class="btn btn-primary" id="doSaveTopic" style="display: none;">Сохранить</button>
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
      var issue_id = \'';push @p,$v->{'i'}->{'issue_id'};push @p,'\';

      $(\'.deleteAnnounce\').click(function(){
        var aname = $(this).attr(\'aname\');
        var aid = $(this).attr(\'aid\');
        if(confirm(\'Удалить "\' + aname + \'"?\')) {
          $.post(
          \'/cgi-bin/index.cgi\', {
            pkg: \'content:a\',
            action: \'delete_announce\',
            aName: aname,
            aid: aid,
            issue_id: issue_id
          },
          function(data, textStatus){
            if(!data || !$.evalJSON(data)) {
              alert(\'Error!\');
            }
            if ($.evalJSON(data).error == 1) {
              alert(\'Ошибка!\');
            } else {
              // alert($.evalJSON(data).issue_id);
              window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=announce&issue_id=\' + issue_id;
            }
          }
        );

        }
      });

      $(\'#doTopic\').click(function(){
        if(!$(\'#aName\').val() || !$(\'#branche\').val() || !$(\'#aBody\').val()) { alert(\'Заполните все поля!\'); return; }
        $.post(
          \'/cgi-bin/index.cgi\', {
            pkg: \'content:a\',
            action: \'create_announce\',
            aName: $(\'#aName\').val(),
            aBody: $(\'#aBody\').val(),
            sbranche: $(\'#sbranche\').val(),
            branche: $(\'#branche\').val(),
            issue_id: issue_id
          },
          function(data, textStatus){
            if(!data || !$.evalJSON(data)) {
              alert(\'Error!\');
            }
            if ($.evalJSON(data).error == 1) {
              alert(\'Статья с таким именем уже есть!\');
            } else {
              // alert($.evalJSON(data).issue_id);
              window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=announce&issue_id=\' + issue_id;
            }
          }
        );
      });

      $(\'.editAnnButton\').click(function(){
        var aname = $(this).attr(\'aname\');
        var aid = $(this).attr(\'aid\');
        var abody = $(this).attr(\'abody\');
        var path = $(this).attr(\'path\');
        var item = $(this).attr(\'item\');
        var ctime = $(this).attr(\'ctime\');
        $(\'#sbranche\').attr(\'disabled\', \'disabled\');
        $(\'#sbranche\').empty();
        $(\'#aName\').val(aname);
        $(\'#aBody\').val(abody);
        $(\'#doTopic\').css(\'display\', \'none\');
        $(\'#doSaveTopic\').css(\'display\', \'inline\');
        $(\'#doSaveTopic\').unbind(\'click\');
        $(\'#doSaveTopic\').click(function(){
          if(!$(\'#aName\').val() || !$(\'#branche\').val() || !$(\'#aBody\').val()) { alert(\'Заполните все поля!\'); return; }
          $.post(
            \'/cgi-bin/index.cgi\', {
              pkg: \'content:a\',
              action: \'save_announce\',
              aName: $(\'#aName\').val(),
              aBody: $(\'#aBody\').val(),
              sbranche: $(\'#sbranche\').val(),
              branche: $(\'#branche\').val(),
              issue_id: issue_id,
              aid: aid,
              ctime: ctime
            },
            function(data, textStatus){
              if(!data || !$.evalJSON(data)) {
                alert(\'Error!\');
              }
              if ($.evalJSON(data).error == 1) {
                alert(\'Ошибка!\');
              } else {
                // alert($.evalJSON(data).issue_id);
                window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=announce&issue_id=\' + issue_id;
              }
            }
          );          
        });
        $(\'#myModalLabel\').html(\'Редактирование\');
        loadStructure(path, item);
      });

      $(\'#addAnnButton\').click(function(){
        $(\'#sbranche\').attr(\'disabled\', \'disabled\');
        $(\'#sbranche\').empty();
        $(\'#aName\').val(\'\');
        $(\'#aBody\').val(\'\');
        $(\'#myModalLabel\').html(\'Добавить анонс\');
        $(\'#doTopic\').css(\'display\', \'inline\');
        $(\'#doSaveTopic\').css(\'display\', \'none\');
        loadStructure();
      });
    
      $(\'#branche\').change(function(){
        var path = $(\'#branche\').val();
        $(\'#sbranche\').attr(\'disabled\', \'disabled\');
        $(\'#sbranche\').empty();
        if(!path) { return; }
        if(sStructure[$(\'#branche\').val()].items) {
          $("#sbranche").append(\'<option value="">Подраздел</option>\');
          for (var i = 1; i < 100; i++) {
            var existTopic = false;
            for (var topic in sStructure[path].items) {
              if(sStructure[path].items[topic].sort_id == i) {
                $("#sbranche").append(\'<option value="\' + topic +\'">\' + sStructure[path].items[topic].name + \'</option>\');
                existTopic = true;
              }
            }
            if(!existTopic) break;
          }
          $(\'#sbranche\').removeAttr(\'disabled\');
        }
      });

      function showBranche() {
        $(\'#branche\').empty();
        $("#branche").append(\'<option value="" selected>Раздел</option>\');
        $("#branche").append(\'<option value="__main">Главный анонс</option>\');
        $("#branche").append(\'<option value="__main_lenta">Главная лента анонсов</option>\');
        for (var i = 1; i < 100; i++) {
          var existTopic = false;
          for (var topic in sStructure) {
            if(sStructure[topic].sort_id == i) {
              $("#branche").append(\'<option value="\' + topic +\'">\' + sStructure[topic].name + \'</option>\');
              existTopic = true;
            }
          }
          if(!existTopic) break;
        }
      }

      function loadStructure(path, item) {
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
              showBranche();
              if(path) {
                $(\'#branche\').val(path);
                if(item) {
                  if(sStructure[$(\'#branche\').val()].items) {
                    $("#sbranche").append(\'<option value="">Подраздел</option>\');
                    for (var i = 1; i < 100; i++) {
                      var existTopic = false;
                      for (var topic in sStructure[path].items) {
                        if(sStructure[path].items[topic].sort_id == i) {
                          $("#sbranche").append(\'<option value="\' + topic +\'">\' + sStructure[path].items[topic].name + \'</option>\');
                          existTopic = true;
                        }
                      }
                      if(!existTopic) break;
                    }
                    $(\'#sbranche\').removeAttr(\'disabled\');
                  }
                  $(\'#sbranche\').val(item);
                }
              }        
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
