# Generated: Sun Feb 10 17:06:27 2019
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
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon1">&raquo;</span>
        <input type="text" class="form-control" id="iname" aria-describedby="basic-addon1" value="';push @p,$v->{'i'}->{'name'};push @p,'">
      </div>
      <div class=\'input-group date\' id=\'datetimepicker1\'>
          <span class="input-group-addon" id="basic-addon4">&raquo;</span>
          <input type=\'text\' class="form-control" id="itime" value="';push @p,$v->{'i'}->{'date_time'};push @p,'"/>
          <span class="input-group-addon">
              <span class="glyphicon glyphicon-calendar"></span>
          </span>
      </div>
      <!-- <div class="input-group">
          <span class="input-group-addon" id="basic-addon4">&raquo;</span>
          <input type="text" class="form-control" name="date_time" aria-describedby="basic-addon1" value="';push @p,$v->{'i'}->{'date_time'};push @p,'">
      </div> -->
      <div class="input-group">
        <span class="input-group-addon" id="basic-addon2">&raquo;</span>
        <select class="form-control" name="Branche" id="branche">
          <!-- <option value="" selected>Раздел</option> -->
        </select>
      </div>
      <div class="input-group">
          <span class="input-group-addon" id="basic-addon3">&raquo;</span>
          <select class="form-control" name="sBranche" id="sbranche" disabled>
            <option value="" selected>Раздел</option>
          </select>
      </div>
      <div class="input-group">
          <span class="input-group-addon" id="basic-addon4">&raquo;</span>
          <textarea class="form-control" id="ibody" name="date_time" aria-describedby="basic-addon1" style="height:300px">';push @p,$v->{'i'}->{'body'};push @p,'</textarea>
      </div>
      <div class="input-group" style="width:100%;text-align:right;padding-top:4px">
          <span style="padding-right:15px;color:#cc0000" id="savinfo"></span>
          <input class="btn btn-warning" style="outline:none;" id="prev" type="button" value="Посмотреть"><span> </span>
          <input class="btn btn-success" style="outline:none;" id="save" type="button" value="Сохранить">
      </div>
      <div class="form-group">
        <label>Upload Image</label>
        <div class="input-group">
            <span class="input-group-btn">
                <span class="btn btn-default btn-file">
                    Выбрать файл <input type="file" id="imgInp">
                </span>
            </span>
            <input type="text" id="textImgInp" class="form-control" readonly>
            <span class="input-group-btn">
              <span class="btn btn-default" id="add_image">
                  Добавить файл
              </span>
          </span>
        </div>
        <p><img id=\'img-upload\'/></p>
      </div>
      <div>
        <table width="100%">
            <tr>
              <td class="issue_table_header" ><span class="glyphicon glyphicon-picture"></span></td>
              <td class="issue_table_header" >Название файла</td>
              <td class="issue_table_header" >Строка для вставки</td>
              <td class="issue_table_header" >Размер</td>
              <td class="issue_table_header" >Дата</td>
              <td class="issue_table_header" ></td>
            </tr>
            ';my $var=$v->{'img'};if (ref $var eq 'ARRAY') {my $saved=$v->{'i'};$v->{'i'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'i'}=$element;push @p,'
            <tr>
              <td class="issue_table" style="width:100px;"><a class="prevImg" data-toggle="modal"
                data-target="#addTopic" style="cursor:pointer;" img="';push @p,$v->{'i'}->{'url'};push @p,'" label="';push @p,$v->{'i'}->{'name'};push @p,'"><img src="';push @p,$v->{'i'}->{'url'};push @p,'" 
                class="img-thumbnail"></a></td>
              <td class="issue_table" >';push @p,$v->{'i'}->{'name'};push @p,'</td>
              <td class="issue_table" style="font-weight: normal;">[CENTER_IMG=';push @p,$v->{'i'}->{'url'};push @p,']</td>
              <td class="issue_table" >';push @p,$v->{'i'}->{'size'};push @p,'</td>
              <td class="issue_table" >';push @p,$v->{'i'}->{'time_str'};push @p,'</td>
              <td class="issue_table" ><a class="deleteImg" img="';push @p,$v->{'i'}->{'name'};push @p,'" style="cursor:pointer;"><span 
                class="glyphicon glyphicon-remove-sign"></span></a></td>
            </tr>
          ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'i'}=$saved;}push @p,'
        </table>
      </div>
    </div>
    <div class="container"></div>

    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

    <!-- Модаль -->
    <div class="modal fade" id="addTopic" tabindex="-1" role="dialog" aria-labelledby="ddTopicLabel">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 class="modal-title" id="myModalLabel"></h4>
            </div>
            <div class="modal-body">
              <img id="prev_img" class="img-responsive img-thumbnail">
            </div>
            <!-- <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal" id="closeDialog">Закрыть</button>
            </div> -->
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
    <script src="/js/moment-with-locales.js"></script>
    <script src="/js/bootstrap-datetimepicker.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="/js/ie10-viewport-bug-workaround.js"></script>
    <script type="text/javascript">
      var sStructure = {};
      var iPath = \'';push @p,$v->{'i'}->{'path'};push @p,'\';
      var iItem = \'';push @p,$v->{'i'}->{'item'};push @p,'\';
      var issue_id = \'';push @p,$v->{'i'}->{'issue_id'};push @p,'\';
      // alert(issue_id);
      loadStructure();

      $(function () {
        $(\'#datetimepicker1\').datetimepicker({
          locale: \'ru\'
        });
      });

      $(\'.deleteImg\').click(function(){
        var img = $(this).attr(\'img\');
        if(!confirm("Удалить " + img + \'?\')) {return};
        $.post(
          \'/cgi-bin/index.cgi\', {
            pkg: \'content:a\',
            action: \'delete_issue_img\',
            img: img,
            issue_id: issue_id
          },
          function(data, textStatus){
            try {
              var response = $.evalJSON(data);
            }
            catch(e) {
              alert(\'Error: \' + e);
              return;
            } 
            if(response.error == \'none\') {
              window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=edit_issue&issue_id=\' + issue_id;
            }
          }
        );
      });

      $(\'.prevImg\').click(function(){
        var img = $(this).attr(\'img\');
        var label = $(this).attr(\'label\');
        // alert(img);
        $(\'#prev_img\').attr(\'src\', img);
        $(\'#myModalLabel\').html(label);
      });

      $(\'#add_image\').click(function(){
        // alert(issue_id);
        var formData = new FormData();
        formData.append(\'file\', $(\'#imgInp\')[0].files[0]);

        $.ajax({
          url : \'/cgi-bin/index.cgi?pkg=content:a&action=issue_img_add&issue_id=\' + issue_id,
          type : \'POST\',
          data : formData,
          processData: false,  // tell jQuery not to process the data
          contentType: false,  // tell jQuery not to set contentType
          success : function(data) {
            try {
              var response = $.evalJSON(data);
            }
            catch(e) {
              alert(\'Error: \' + e);
              return;
            } 
            if(response[\'error\'] != \'none\') {
              alert(response[\'error\']);
              return;
            }
            window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=edit_issue&issue_id=\' + issue_id;
          }             
        });

      });

      $(\'#save\').click(function(){
        if(!$(\'#iname\').val() || !$(\'#itime\').val() || !$(\'#branche\').val() || !$(\'#ibody\').val()) {
          alert(\'Не все поля заполнены!\');
          return;
        }
        $.post(
          \'/cgi-bin/index.cgi\', {
            pkg: \'content:a\',
            action: \'save_issue\',
            iname: $(\'#iname\').val(),
            itime: $(\'#itime\').val(),
            branche: $(\'#branche\').val(),
            sbranche: $(\'#sbranche\').val(),
            ibody: $(\'#ibody\').val(),
            issue_id: issue_id
          },
          function(data, textStatus){
            try {
              var response = $.evalJSON(data);
            }
            catch(e) {
              alert(\'Error: \' + e);
              return;
            } 
            if(response.status == \'ok\') {
              $(\'#savinfo\').html(\'Изменения сохранены!\');
              setTimeout(function(){ $(\'#savinfo\').html(\'\'); }, 800);
            }
          }
        );

        // alert($(\'#ibody\').val());
      });

      $(\'#prev\').click(function(){
        $(\'#save\').trigger(\'click\');
        // alert(\'prev\');
        setTimeout(function(){
          window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=issue_prev&issue_id=\' + issue_id;
        }, 1500);
      });

      $(\'#branche\').change(function(){
        var path = $(\'#branche\').val();
        iPath = path;
        iItem = \'\';
        change_sbranche(path, 1);
      });

      function change_sbranche(path, addon) {
        $(\'#sbranche\').attr(\'disabled\', \'disabled\');
        $(\'#sbranche\').empty();
        if(!path) { return; }
        if(sStructure[path].items) {
          if(addon) { $("#sbranche").append(\'<option value="">Выбрать подраздел</option>\'); }
          for (var i = 1; i < 100; i++) {
            var existTopic = false;
            for (var topic in sStructure[path].items) {
              if(sStructure[path].items[topic].sort_id == i) {
                var selected = \'\';
                if(topic == iItem) {
                  selected = \' selected\';
                }
                $("#sbranche").append(\'<option value="\' + topic +\'"\' + selected + \'>\' + sStructure[path].items[topic].name + \'</option>\');
                existTopic = true;
              }
            }
            if(!existTopic) break;
          }
          $(\'#sbranche\').removeAttr(\'disabled\');
        }
      } 

      function showBranche() {
        $(\'#branche\').empty();
        // $("#branche").append(\'<option value="" selected>Раздел</option>\');
        for (var i = 1; i < 100; i++) {
          var existTopic = false;
          for (var topic in sStructure) {
            if(sStructure[topic].sort_id == i) {
              var selected = \'\';
              if(iPath == topic) {
                selected = \' selected\';
              }
              $("#branche").append(\'<option value="\' + topic +\'"\' + selected + \'>\' + sStructure[topic].name + \'</option>\');
              existTopic = true;
            }
          }
          if(!existTopic) break;
        }
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
              // alert(data);
              sStructure = $.evalJSON(data);
              showBranche();
              change_sbranche(iPath);
            }
          }
        );
      }

    $(document).ready( function() {
    	$(document).on(\'change\', \'.btn-file :file\', function() {
		    var input = $(this),
			  label = input.val().replace(/\\\\/g, \'/\').replace(/.*\\//, \'\');
		    input.trigger(\'fileselect\', [label]);
		  });

		$(\'.btn-file :file\').on(\'fileselect\', function(event, label) {
		    
		    var input = $(this).parents(\'.input-group\').find(\':text\'),
		        log = label;
		    
		    if( input.length ) {
		        input.val(log);
		    } else {
		        if( log ) alert(log);
		    }
	    
		});
		function readURL(input) {
		    if (input.files && input.files[0]) {
		        var reader = new FileReader();
		        
		        reader.onload = function (e) {
		            $(\'#img-upload\').attr(\'src\', e.target.result);
		        }
		        
		        reader.readAsDataURL(input.files[0]);
		    }
		}

		$("#imgInp").change(function(){
		    readURL(this);
		}); 	
    });
    </script>
  </body>
</html>

<!-- $VAR1 = {
  \'t_item\' => "\\x{d0}\\x{98}\\x{d1}\\x{81}\\x{d1}\\x{82}\\x{d0}\\x{be}\\x{d1}\\x{80}\\x{d0}\\x{b8}\\x{d1}\\x{8f}",
  \'date_time\' => 1548586195,
  \'data\' => {
              \'name\' => "\\x{d0}\\x{a2}\\x{d0}\\x{b5}\\x{d1}\\x{81}\\x{d1}\\x{82}\\x{d0}\\x{be}\\x{d0}\\x{b2}\\x{d0}\\x{b0}\\x{d1}\\x{8f} \\x{d1}\\x{81}\\x{d1}\\x{82}\\x{d0}\\x{b0}\\x{d1}\\x{82}\\x{d1}\\x{8c}\\x{d1}\\x{8f} 2"
            },
  \'issue_id\' => \'F2EFCC4DF1603FEB1940CC6998550A46\',
  \'name\' => "\\x{d0}\\x{a2}\\x{d0}\\x{b5}\\x{d1}\\x{81}\\x{d1}\\x{82}\\x{d0}\\x{be}\\x{d0}\\x{b2}\\x{d0}\\x{b0}\\x{d1}\\x{8f} \\x{d1}\\x{81}\\x{d1}\\x{82}\\x{d0}\\x{b0}\\x{d1}\\x{82}\\x{d1}\\x{8c}\\x{d1}\\x{8f} 2",
  \'t_path\' => "\\x{d0}\\x{9e} \\x{d0}\\x{93}\\x{d0}\\x{b5}\\x{d1}\\x{80}\\x{d0}\\x{bc}\\x{d0}\\x{b0}\\x{d0}\\x{bd}\\x{d0}\\x{b8}\\x{d0}\\x{b8}",
  \'path\' => \'deutschland\',
  \'item\' => \'geschichte.html\'
}; -->';
$s->{parsed}=join('',@p);
};
1;