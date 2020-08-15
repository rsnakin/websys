# Generated: Sun Mar 10 11:25:34 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'
var timeoutId;
var cCanvas;
var captchaCode;
function initCapcha() {
    if(timeoutId) { clearTimeout(timeoutId); }
    $(\'#captchaDiv\').html(\'<canvas id="captchaCanvas" />\');
    $(\'#captchaCanvas\').attr(\'style\', \'border:1px solid #e95420\');
    cCanvas = document.getElementById(\'captchaCanvas\');
    var cDrv = cCanvas.getContext(\'2d\');
    cCanvas.width = $(\'#captchaDiv\').width() - 3;
    cCanvas.height = ($(\'#captchaDiv\').width() / 6) - 3;
    march(cDrv);
    var img = new Image();
    img.onload = function(){
      cDrv.drawImage(img, 0, 0)
    }
    $.post(
        \'/cgi-bin/index.cgi\', {
          pkg: \'content:forum\',
          action: \'captcha\',
          width: cCanvas.width,
          height: cCanvas.height
        },
        function(data, textStatus){
          var response;
          try {
            response = $.evalJSON(data);
          }
          catch(e) {
              alert(e);
              return;
          }
          clearTimeout(timeoutId);
          $(\'#captchaCanvas\').attr(\'style\', \'border:1px solid #fff\');
          img.src = response.img;
          captchaCode = response.code;
        }
      );
}
var offset = 0;
function draw(drv) {
  drv.clearRect(0, 0, cCanvas.width, cCanvas.height);
  drv.beginPath();
  drv.strokeStyle = \'rgba(255, 255, 255, .1)\';
  drv.lineWidth = cCanvas.height * .35;
  drv.setLineDash([40, 20]);
  drv.lineDashOffset = offset;
  drv.moveTo(0, cCanvas.height * .25);
  drv.lineTo(cCanvas.width, cCanvas.height * .25);
  drv.stroke();
  drv.beginPath();
  drv.lineDashOffset = - offset;
  drv.moveTo(0, cCanvas.height * .75);
  drv.lineTo(cCanvas.width, cCanvas.height * .75);
  drv.stroke();
}

function march(drv) {
  offset++;
  if (offset > 60) {
    offset = 0;
  }
  draw(drv);
  timeoutId = setTimeout(function(){ march(drv); }, 10);
}

$(\'#captcha_refresh\').click(function(){
  $(\'#captchaDiv\').html(\'\');
  initCapcha();
});

';
$s->{parsed}=join('',@p);
};
1;
