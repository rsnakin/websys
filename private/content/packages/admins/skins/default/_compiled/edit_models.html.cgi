# Generated: Thu Oct 19 19:33:22 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;border:1px dotted #000">
<form method="post">
<input type="hidden" name="action" value="edit_models">
<input type="hidden" name="pkg" value="content:admins">
<table width="100%">
  <tr>
    <td valign="top" align="center" style="border-top:1px dotted #CCC" width="33%">
      Категории
      <select name="categories" multiple="multiple" style="width:100%;height:100px">
        ';my $var=$v->{'cats'};if (ref $var eq 'ARRAY') {my $saved=$v->{'c'};$v->{'c'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'c'}=$element;push @p,'<option value="';push @p,$v->{'c'}->{'category_id'};push @p,'" ';push @p,$v->{'c'}->{'selected'};push @p,'>';push @p,$v->{'c'}->{'category_name'};push @p,'</option>';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'c'}=$saved;}push @p,'
      </select>
    </td>
    <td valign="top" align="center" style="border-top:1px dotted #CCC" width="33%">
      Производители
      <select name="brands" multiple="multiple" style="width:100%;height:100px">
        ';my $var=$v->{'brands'};if (ref $var eq 'ARRAY') {my $saved=$v->{'b'};$v->{'b'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'b'}=$element;push @p,'<option value=';push @p,$v->{'b'}->{'brand_id'};push @p,' ';push @p,$v->{'b'}->{'selected'};push @p,'>';push @p,$v->{'b'}->{'brand_name'};push @p,'</option>';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'b'}=$saved;}push @p,'
      </select>
    </td>
    <td valign="top" align="center" style="border-top:1px dotted #CCC" width="33%">
      Марки
      <select name="marks" multiple="multiple" style="width:100%;height:100px">
        ';my $var=$v->{'marks'};if (ref $var eq 'ARRAY') {my $saved=$v->{'m'};$v->{'m'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'m'}=$element;push @p,'<option value=';push @p,$v->{'m'}->{'mark_id'};push @p,' ';push @p,$v->{'m'}->{'selected'};push @p,'>';push @p,$v->{'m'}->{'mark_name'};push @p,'</option>';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'m'}=$saved;}push @p,'
      </select>
    </td>
  </tr>
  <tr>
    <td align="right">
    URL:
    </td>
    <td colspan="2">
    <a href="/models/';push @p,$v->{'model'}->{'text_id'};push @p,'.html" target="__';push @p,$v->{'model'}->{'text_id'};push @p,'">/models/';push @p,$v->{'model'}->{'text_id'};push @p,'.html</a>
    </td>
  </tr>
  <tr>
    <td align="right">
    Название:
    </td>
    <td colspan="2">
    <input type="text" name="model_name" style="width:100%" value="';push @p,$v->{'model'}->{'model_name'};push @p,'">
    </td>
  </tr>
  <tr>
    <td align="right">
    Год выпуска:
    </td>
    <td colspan="2">
    <input type="text" name="model_year" style="width:100%" value="';push @p,$v->{'model'}->{'model_year'};push @p,'">
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">
    Общие данные об автомобиле:
    </td>
    <td colspan="2">
    <textarea name="model_common" style="width:100%;height:100px;resize:none;">';push @p,$v->{'model'}->{'model_common'};push @p,'</textarea>
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">
    Характеристика автомобиля:
    </td>
    <td colspan="2">
    <textarea name="model_char" style="width:100%;height:100px;resize:none;">';push @p,$v->{'model'}->{'model_char'};push @p,'</textarea>
    </td>
  </tr>
  <tr>
    <td align="right" valign="top">
    Описание модели:
    </td>
    <td colspan="2">
    <textarea name="model_desc" style="width:100%;height:100px;resize:none;">';push @p,$v->{'model'}->{'model_desc'};push @p,'</textarea>
    </td>
  </tr>
  <tr>
    <td align="right">
    </td>
    <td colspan="2">
    <input type="submit" name="save" value="Сохранить"> <span style="cursor:pointer" id="bgs"><b>[Подложка]</b></span>
    </td>
  </tr>
</table>
</form>
<div id="titlebgs" style="width:100%;text-align:center;"></div>
<div id="titlebg"></div>
<div style="width:98%;height:2px;background:#fff;padding:10px;border-top:1px dotted #000"></div>
<div id="uploader" style="width:98%;background:#fff;padding:10px;border-bottom:1px dotted #000">
<form action="/cgi-bin/index.cgi?action=upload_picture&pkg=content:admins&model_id=';push @p,($EnLR=$in->query('model_id'));push @p,'" class="dropzone" id="upzone">
  <div class="fallback" style="background:#fff;padding:10px;border:1px dotted #000">
    <input name="file" type="file" multiple />
  </div>
</form>
</div>
<div id="images" style="display:none;width:100%;text-align:center;"></div>
<div id="button" style="text-align:right;width:100%;display:none;"><button id="done" style="display:inline">Далее</button></div>
<div id="iset" style="display:none;width:100%;text-align:center;padding:5px;"></div>
</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,'<script type="text/javascript" src="/a/js/dropzone.js"></script>
<!-- <script type="text/javascript" src="/a/fbox/jquery.fancybox.pack.js"></script> -->
<script type="text/javascript">
var imageObj;
var X;
var Y;
var Xrect;
var Yrect;
var response;
var RECTX = 800;
var RECTY = 800;
Dropzone.options.upzone = {
  paramName: "file", // The name that will be used to transfer the file
  maxFilesize: 20, // MB
  success: function(e,obj) {
    response = jQuery.parseJSON(obj);
    if(response[\'error\']) { alert(response[\'error\']); return; }
    edit_image(response);
  },
  addedfile: function() {
    $(\'body\').css(\'cursor\', \'wait\');
  },
  previewTemplate: \'<div></div>\'
};

init_images();

function init_images() {
  $.post(
    \'/cgi-bin/index.cgi\',
    {
      pkg: \'content:admins\',
      action: \'get_images\',
      model_id: ';push @p,$EnLR;push @p,'
    },
    function(data, textStatus){
      var images = jQuery.parseJSON(data);
      if(!images[\'html\']) {
        $(\'#iset\').css(\'display\', \'block\');
        $(\'#iset\').html(\'<div style="display:inline">Нет изображений</div>\');
      } else {
        $(\'#iset\').css(\'display\', \'block\');
        $(\'#iset\').html(images[\'html\']);
      }
    }
  );  
}

function edit_image(obj) {
  $(\'#uploader\').css(\'display\', \'none\');
  $(\'#images\').css(\'display\', \'block\');
  $(\'#images\').html(\'<canvas id="canvas_obj" style="align:center;padding:0px;border: 1px solid #444;display:inline;"></canvas>\');
  var canvas = document.getElementById(\'canvas_obj\');
  canvas.width = obj[\'x\'];
  canvas.height = obj[\'y\'];
  imageObj = new Image();  
  imageObj.onload = function() {
    Rect(obj[\'x\'] / 2, obj[\'y\'] / 2);
    Xrect = obj[\'x\'] / 2;
    Yrect = obj[\'y\'] / 2
    bindMouse();
    $(\'#button\').css(\'display\', \'block\');
    $(\'#button\').click(function(){
      $(\'#button\').unbind(\'click\');
      $(\'#button\').css(\'display\', \'none\');
      img_done();
    });
  };
  imageObj.src = obj[\'url\'];
}
function Rect(x, y) {
  var canvas = document.getElementById(\'canvas_obj\');
  var drv = canvas.getContext(\'2d\');
  drv.drawImage(imageObj, 0, 0, canvas.width, canvas.height);
  drv.beginPath();
  drv.strokeStyle = "rgba(128, 255, 192, .8)";
  drv.strokeRect(x - (RECTX/2), y - (RECTY/2), RECTX, RECTY);
  drv.stroke();
  drv.closePath();
  $(\'body\').css(\'cursor\', \'default\');
}
function bindMouse() {
  $(\'#canvas_obj\').click(function(e){
//     $(\'#dbg\').html(\'bind1\');
    X = e.pageX;
    Y = e.pageY;
    $( "#canvas_obj" ).css(\'cursor\', \'move\');
    $( "#canvas_obj" ).mousemove(function( event ) {
//       var msg = "Handler for .mousemove() called at ";
//       msg += event.pageX + ", " + event.pageY;
      Xrect = Xrect - (X - event.pageX);
      Yrect = Yrect - (Y - event.pageY);
      X = event.pageX;
      Y = event.pageY;
      Rect(Xrect, Yrect);
//       $(\'#dbg\').html(msg);
    });
    $(\'#canvas_obj\').unbind(\'click\');
    $(\'#canvas_obj\').click(function(){
//       $(\'#dbg\').html(\'bind2\');
      $(\'#canvas_obj\').unbind(\'mousemove\');
      $(\'#canvas_obj\').unbind(\'click\');
      $( "#canvas_obj" ).css(\'cursor\', \'default\');
      bindMouse();
    });
  });
}
function img_done() {
  $(\'#canvas_obj\').unbind(\'click\');
  $(\'#canvas_obj\').unbind(\'mousemove\');
  var image_id = response[\'image_id\'];
  var x = Xrect;
  var y = Yrect;
//   alert(\'image_id = \' + image_id + "\\nX = " + x + "\\nY = " + y);
  $.post(
    \'/cgi-bin/index.cgi\',
    {
      pkg: \'content:admins\',
      action: \'save_image\',
      image_id: image_id,
      x: x,
      y: y,
      rectx: RECTX,
      recty: RECTY,
      model_id: ';push @p,$EnLR;push @p,'
    },
    function(data, textStatus){
      $(\'#images\').css(\'display\', \'block\');
      $(\'#images\').html(\'\');
      $(\'#uploader\').css(\'display\', \'block\');
      init_images();
    }
  );  
}
$(\'#bgs\').click(function(){
  $.post(
    \'/cgi-bin/index.cgi\',
    {
      pkg: \'content:admins\',
      action: \'get_bgs\'
    },
    function(data, textStatus){
      var images = jQuery.parseJSON(data);
      if(!images[\'html\']) {
        $(\'#titlebgs\').css(\'display\', \'block\');
        $(\'#titlebgs\').html(\'<div style="display:inline">Error!</div>\');
      } else {
        $(\'#titlebgs\').css(\'display\', \'block\');
        $(\'#titlebgs\').html(\'<span id="closebgs" style="cursor:pointer;">[<u>Close<u>]</span>\' + images[\'html\']);
        $(\'#closebgs\').click(function(){
          $(\'#titlebgs\').css(\'display\', \'none\');
          $(\'#titlebgs\').html(\'\');
          $(\'#closebgs\').unbind(\'click\');
        });
        $(\'.bgsclick\').css(\'cursor\', \'pointer\');
        $(\'.bgsclick\').click(function(){
          var bgid = $(this).attr(\'oo\');
          $.post(
            \'/cgi-bin/index.cgi\',
            {
              pkg: \'content:admins\',
              action: \'bind_bg\',
              model_id: \'';push @p,$EnLR;push @p,'\',
              bgid: bgid
            },
            function(data, textStatus){
              init_bg();
              $(\'#titlebgs\').css(\'display\', \'none\');
              $(\'#titlebgs\').html(\'\');
            }
          );
        });
      }
    }
  );
});
function init_bg() {
  $.post(
    \'/cgi-bin/index.cgi\',
    {
      pkg: \'content:admins\',
      action: \'get_bg\',
      model_id: \'';push @p,$EnLR;push @p,'\'
    },
    function(data, textStatus){
      var images = jQuery.parseJSON(data);
      if(images[\'image\']) {
        $(\'#titlebg\').html(\'<img src="\' + images[\'image\'] + \'">\');
      }
    }
  );
}
init_bg();
</script>
';push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
