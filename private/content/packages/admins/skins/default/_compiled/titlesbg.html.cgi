# Generated: Thu Dec 21 11:57:04 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,$s->{pkg}->_template('inc/top.html')->parse($v);push @p,'<div class="uk-width-8-10" style="background:#fff;padding:10px;border:1px dotted #000">
<form action="/cgi-bin/index.cgi?action=upload_bg&pkg=content:admins" class="dropzone" id="upzone">
  <div class="fallback" style="background:#fff;padding:10px;border:1px dotted #000">
    <input name="file" type="file" multiple />
  </div>
</form>
<div id="images"></div>
<div id="button" style="text-align:right;width:100%;display:none;"><button id="done" style="display:inline">Далее</button></div>
<div id="iset"></div>
</div>
';push @p,$s->{pkg}->_template('inc/bottom.html')->parse($v);push @p,$s->{pkg}->_template('inc/jss.html')->parse($v);push @p,$s->{pkg}->_template('inc/jsscommon.html')->parse($v);push @p,'<script type="text/javascript" src="/a/js/dropzone.js"></script>
<script type="text/javascript">

var imageObj;
var X;
var Y;
var Xrect;
var Yrect;
var response;
var RECTX = 1180;
var RECTY = 400;
Dropzone.options.upzone = {
  paramName: "file", // The name that will be used to transfer the file
  maxFilesize: 20, // MB
  success: function(e,obj) {
    response = jQuery.parseJSON(obj);
    if(response[\'error\']) { alert(response[\'error\']); return; }
    imageObj = response;
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
      action: \'get_bgs\'
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
  drv.strokeStyle = "rgba(255, 255, 255, 1)";
  drv.strokeRect(x - (RECTX/2) - 1, y - (RECTY/2), RECTX + 1, RECTY);
  drv.stroke();
//   drv.strokeStyle = \'rgba(0, 0, 0, 1)\';
//   drv.strokeRect(0, y - (RECTY/2), 1180, y - (RECTY/2));
//   drv.strokeRect(0, y - (RECTY/2) + 1, 1180, y - (RECTY/2) + 1);
//   drv.stroke();
//   var gradient = drv.createLinearGradient(x - (RECTX/2) + 100, y - (RECTY/2), x - (RECTX/2) + 100, y);
//   gradient.addColorStop(0, \'black\');
//   gradient.addColorStop(1, \'rgba(255, 192, 24, 0.8)\');
//   drv.fillStyle = gradient;
//   drv.fillRect(0, y - (RECTY/2), 1180, RECTY/2);//   drv.strokeRect(x - (RECTX/2) + 100, y - (RECTY/2), RECTX - 200, RECTY);
  var gradient = drv.createLinearGradient(x - (RECTX/2) + 100, y - (RECTY/2), x - (RECTX/2) + 100, y + (RECTY/2));
  gradient.addColorStop(1, \'white\');
  gradient.addColorStop(0, \'rgba(220, 220, 220, 0.6)\');
  drv.fillStyle = gradient;
  drv.fillRect(0, y - (RECTY/2), 1180, RECTY);//   drv.strokeRect(x - (RECTX/2) + 100, y - (RECTY/2), RECTX - 200, RECTY);
  drv.fillStyle = \'white\';
  drv.fillRect(0, 0, 1180, y - RECTY/2);
  drv.fillRect(0, y + RECTY/2, 1180, canvas.height);
  drv.strokeStyle = \'rgba(255, 255, 255, 1)\';
  drv.strokeRect(0, y - (RECTY/2) - 1, 1180, 2);
//   drv.strokeRect(0, y - (RECTY/2) + 1, 1180, y - (RECTY/2) + 1);
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
      Xrect = RECTX / 2;
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
  var currentCanvas = document.getElementById(\'canvas_obj\');
  if(currentCanvas.toBlob) {
    currentCanvas.toBlob(function(blob) {
      var reader = new window.FileReader();
      reader.readAsDataURL(blob); 
      reader.onloadend = function(){

        $.post(
          \'/cgi-bin/index.cgi\',
          {
            pkg: \'content:admins\',
            action: \'save_bg\',
            image_id: image_id,
            x: x,
            y: y,
            rectx: RECTX,
            recty: RECTY,
            imgblob: reader.result,
            width: currentCanvas.width,
            height: currentCanvas.height
          },
          function(data, textStatus){
            $(\'#images\').css(\'display\', \'block\');
            $(\'#images\').html(\'\');
            $(\'#uploader\').css(\'display\', \'block\');
            init_images();
          }
        );  
      
      
      
      };
    }, \'image/jpeg\');
  }
  return;
//   alert(\'image_id = \' + image_id + "\\nX = " + x + "\\nY = " + y);
}

  
</script>
';push @p,$s->{pkg}->_template('inc/end.html')->parse($v);push @p,'

';
$s->{parsed}=join('',@p);
};
1;
