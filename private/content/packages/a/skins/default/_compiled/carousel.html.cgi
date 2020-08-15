# Generated: Sat Feb  2 19:45:31 2019
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
    <div class="container" style="padding-top:20px;">
      <div class="blog-header">
        <h3 class="blog-title">Карусель</h3>
        <hr>
      </div>
      <table width="100%">
        <tr>
          <td class="issue_table_header" width="5%"><span class="glyphicon glyphicon-hand-down"></span></td>
          <td class="issue_table_header" width="10%"><span class="glyphicon glyphicon-picture"></span></td>
          <td class="issue_table_header" width="35%">Название</td>
          <td class="issue_table_header" width="22%">Раздел</td>
          <td class="issue_table_header" width="22%">Подраздел</td>
          <td class="issue_table_header" width="6%"><a class="" data-toggle="modal"
            data-target="#addTopic" id="addTopicButton" style="cursor:pointer;"><span 
            class="glyphicon glyphicon-file" aria-hidden="true"></span></a></td>
        </tr>
        ';my $var=$v->{'carousel'};if (ref $var eq 'ARRAY') {my $saved=$v->{'i'};$v->{'i'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'i'}=$element;push @p,'
        <tr>
          <td class="issue_table" width="5%"><span cid="';push @p,$v->{'i'}->{'cid'};push @p,'" d="up" style="cursor: pointer;" class="glyphicon glyphicon-arrow-up csort"></span><span d="down" cid="';push @p,$v->{'i'}->{'cid'};push @p,'" style="cursor: pointer;" class="glyphicon glyphicon-arrow-down csort"></span></td>
          <td class="issue_table" width="10%"><img src="';push @p,$v->{'i'}->{'file'};push @p,'" width="80" height="50"></td>
          <td class="issue_table" width="35%"><span cid="';push @p,$v->{'i'}->{'cid'};push @p,'" cimg="';push @p,$v->{'i'}->{'file'};push @p,'" cname="';push @p,$v->{'i'}->{'name'};push @p,'" path="';push @p,$v->{'i'}->{'path'};push @p,'" item="';push @p,$v->{'i'}->{'item'};push @p,'" data-toggle="modal"
              data-target="#addTopic" id="addTopicButton" class="edit_carousel" style="cursor: pointer;"><u>';push @p,$v->{'i'}->{'name'};push @p,'</u></span></td>
          <td class="issue_table" width="22%">';push @p,$v->{'i'}->{'t_path'};push @p,'</td>
          <td class="issue_table" width="22%">';push @p,$v->{'i'}->{'t_item'};push @p,'</td>
          <td class="issue_table" width="6%"><a class="deleteItem" iname="';push @p,$v->{'i'}->{'name'};push @p,'" cid="';push @p,$v->{'i'}->{'cid'};push @p,'" style="cursor:pointer;"><span 
            class="glyphicon glyphicon-remove-sign"></span></a></td>
        </tr>
        ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'i'}=$saved;}push @p,'
      </table>
    </div>
    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

    <!-- Модаль -->
<div class="modal fade" id="addTopic" tabindex="-1" role="dialog" aria-labelledby="ddTopicLabel">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="myModalLabel">Добавить элемент</h4>
        </div>
        <div class="modal-body">
          <p><input type="text" id="bName" name="bName" class="form-control" value="" placeholder="Заголовок элемента" required autofocus></p>
          <!-- <p><input type="text" id="bPath" name="bPath" class="form-control" value="" placeholder="Путь к разделу" required autofocus></p> -->
          <p>
            <select class="form-control" name="bBranche" id="branche">
              <!-- <option value="" selected>Раздел</option> -->
            </select>
          </p>
          <p>
            <select class="form-control" name="bsBranche" id="sbranche" disabled>
              <!-- <option value="">Подраздел</option> -->
            </select>
          </p>
          <div class="form-group">
            <label>Upload Image</label>
            <div class="input-group">
                <span class="input-group-btn">
                    <span class="btn btn-default btn-file">
                        Выбрать файл <input type="file" id="imgInp">
                    </span>
                </span>
                <input type="text" id="textImgInp" class="form-control" readonly>
            </div>
            <p><img id=\'img-upload\'/></p>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal" id="closeDialog">Закрыть</button>
          <button type="button" class="btn btn-primary" id="doTopic" style="display: none">Добавить</button>
          <button type="button" class="btn btn-primary" id="saveTopic" style="display: none">Сохранить</button>
          <input type="hidden" id="cid">
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
      
      $(\'.deleteItem\').click(function(){
        var iid = $(this).attr(\'cid\');
        var iname = $(this).attr(\'iname\');
        if(confirm(\'Удалить "\' + iname + \'"?\')) {
          window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=carousel&delete_carousel_id=\' + iid;
        }
      });

      $(\'.csort\').click(function(){
        var cid = $(this).attr(\'cid\');
        var d = $(this).attr(\'d\');
        // alert(cid + \' \' + d);
        window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=carousel&sort=\' + d + \'&cid=\' + cid;
      });

      $(\'.edit_carousel\').click(function(){
        var cid = $(this).attr(\'cid\');
        var cimg = $(this).attr(\'cimg\');
        var cname = $(this).attr(\'cname\');
        var path = $(this).attr(\'path\');
        var item = $(this).attr(\'item\');
        // alert(cid);
        $(\'#myModalLabel\').html(\'Изменить элемент\');
        $(\'#doTopic\').css(\'display\', \'none\');
        $(\'#saveTopic\').css(\'display\', \'inline\');
        $(\'#imgInp\').val(\'\');
        $(\'#textImgInp\').val(\'\');
        $(\'#img-upload\').attr(\'src\', cimg);
        $(\'#sbranche\').attr(\'disabled\', \'disabled\');
        $(\'#sbranche\').empty();
        $(\'#bName\').val(cname);
        $(\'#cid\').val(cid);
        loadStructure(path, item);
      });

      $(\'#addTopicButton\').click(function(){
        $(\'#myModalLabel\').html(\'Добавить элемент\');
        $(\'#doTopic\').css(\'display\', \'inline\');
        $(\'#saveTopic\').css(\'display\', \'none\');
        $(\'#imgInp\').val(\'\');
        $(\'#textImgInp\').val(\'\');
        $(\'#img-upload\').removeAttr(\'src\');
        $(\'#sbranche\').attr(\'disabled\', \'disabled\');
        $(\'#sbranche\').empty();
        $(\'#bName\').val(\'\');
        loadStructure();
      });

      $(\'#saveTopic\').click(function(){
        if(!$(\'#bName\').val() || !$(\'#branche\').val()) { alert(\'Заполните все поля!\'); return; }

        var formData = new FormData();
        formData.append(\'file\', $(\'#imgInp\')[0].files[0]);

        $.ajax({
          url : \'/cgi-bin/index.cgi?pkg=content:a&action=carousel_save&bName=\' + $(\'#bName\').val() +
          \'&sbranche=\' + $(\'#sbranche\').val() + \'&branche=\' + $(\'#branche\').val() + \'&cid=\' + $(\'#cid\').val(),
          type : \'POST\',
          data : formData,
          processData: false,
          contentType: false,
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
            window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=carousel\';
          }             
        });
      });

      $(\'#doTopic\').click(function(){
        if(!$(\'#bName\').val() || !$(\'#branche\').val()) { alert(\'Заполните все поля!\'); return; }

        var formData = new FormData();
        formData.append(\'file\', $(\'#imgInp\')[0].files[0]);

        $.ajax({
          url : \'/cgi-bin/index.cgi?pkg=content:a&action=carousel_add&bName=\' + $(\'#bName\').val() +
          \'&sbranche=\' + $(\'#sbranche\').val() + \'&branche=\' + $(\'#branche\').val(),
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
            window.location.href = \'/cgi-bin/index.cgi?pkg=content:a&action=carousel\';
          }             
        });
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
              }
              if(item) {
                // $(\'#sbranche\').removeAttr(\'disabled\');
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
                  $(\'#sbranche\').val(item);
                }
              }
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
';
$s->{parsed}=join('',@p);
};
1;
