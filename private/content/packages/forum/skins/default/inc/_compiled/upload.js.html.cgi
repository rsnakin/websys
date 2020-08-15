# Generated: Sat Mar  9 17:46:03 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'
$(document).ready( function() {
    function initCanvas() {
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton picMove" direct="up">\'
        + \'<span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton picMove" direct="down">\'
        + \'<span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton picMove" direct="left">\'
        + \'<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton picMove" direct="right">\'
        + \'<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton picMove" direct="scaleup">\'
        + \'<span class="glyphicon glyphicon-fullscreen" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton picMove" direct="scaledown">\'
        + \'<span class="glyphicon glyphicon-resize-small" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#iTools\').append(\'<button type="button" class="btn fbutton" id="clear_image">\'
        + \'<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>\'
        + \'</button>\');
        $(\'#canvasDiv\').append(\'<canvas id="iCanvas" />\');
        canvas = document.getElementById(\'iCanvas\');
        canvas.width = 0;
        canvas.height = 0;
        drv = canvas.getContext(\'2d\');
        $(\'#clear_image\').unbind(\'click\');
        $(\'#clear_image\').click(function(){
            $(\'#imgInp\').val(\'\');
            $(\'#canvasDiv\').html(\'\');
            $(\'#canvasDiv\').append(\'<canvas id="iCanvas" />\');
            canvas = document.getElementById(\'iCanvas\');
            canvas.width = 0;
            canvas.height = 0;
            drv = canvas.getContext(\'2d\');
            $(\'#canvasDiv\').css(\'display\', \'none\');
            $(\'#textImgInp\').val(\'\');
            $(\'#saveImg\').css(\'display\', \'none\');
            $(\'#iTools\').css(\'display\', \'none\');
            $(\'#img-upload\').attr(\'avatarSelected\', \'no\');
            $(\'#sex\').trigger(\'change\');
            $(\'#iTools\').html(\'\');
        });
    }
    var canvas;
    var scale;
    var dX;
    var dY;
    var drv;
    $(document).on(\'change\', \'.btn-file :file\', function() {
        // alert(\'change\');
        var input = $(this),
          label = input.val().replace(/\\\\/g, \'/\').replace(/.*\\//, \'\');
        input.trigger(\'fileselect\', [label]);
      });

    $(\'.btn-file :file\').on(\'fileselect\', function(event, label) {
        // alert(\'fileselect\');
        initCanvas();
        $(\'#canvasDiv\').css(\'display\', \'inline\');
        $(\'#iTools\').css(\'display\', \'inline\');

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
            var img = new Image();
            reader.onload = function (e) {               
                img.onload = function() {
                    $(\'#iCanvas\').attr(\'style\', \'border:1px solid #fff\');
                    $(\'#saveImg\').css(\'display\', \'inline\');
            
                    if(img.width < img.height) {
                        scale = $(\'#canvasDiv\').width()/img.width;
                    } else {
                        scale = $(\'#canvasDiv\').width()/img.height;
                    }
                    // alert(scale);
                    canvas.width = $(\'#canvasDiv\').width();
                    canvas.height = $(\'#canvasDiv\').width();
                    $(\'#canvasDiv\').height(canvas.height);

                    showImage(drv, img, 0, 0);
                    dX = 0;
                    dY = 0;
                    $( "#iCanvas" ).unbind(\'mousedown\');
                    $( "#iCanvas" ).mousedown(function(eDown) {
                        var ddX = dX;
                        var ddY = dY;    
                        $( "#iCanvas" ).unbind(\'mousemove\');
                        var busy = false;
                        $( "#iCanvas" ).mousemove(function(e) {
                            if(busy) { return; }
                            busy = true;
                            dX = ddX + e.pageX - eDown.pageX;
                            dY = ddY + e.pageY - eDown.pageY;
                            showImage(drv, img, dX, dY);
                            // $(\'#minfo\').html(dX + \' \' + dY);
                            busy = false;
                            $( "#iCanvas" ).mouseup(function() {
                                $( "#iCanvas" ).unbind(\'mousemove\');
                            });        
                            $( "#iCanvas" ).mouseout(function() {
                                $( "#iCanvas" ).unbind(\'mousemove\');
                            });        
                        });
                    });
                    $(\'.picMove\').unbind(\'click\');
                    $(\'.picMove\').click(function(){
                        var dir = $(this).attr(\'direct\');
                        if(dir == \'left\') {
                            dX -= 0.01 * canvas.width;
                            showImage(drv, img, dX, dY);
                        }
                        if(dir == \'right\') {
                            dX += 0.01 * canvas.width;
                            showImage(drv, img, dX, dY);
                        }
                        if(dir == \'up\') {
                            dY -= 0.01 * canvas.height;
                            showImage(drv, img, dX, dY);
                        }
                        if(dir == \'down\') {
                            dY += 0.01 * canvas.height;
                            showImage(drv, img, dX, dY);
                        }
                        if(dir == \'scaleup\') {
                            scale += 0.05 * scale;
                            if(scale <= 2) {
                                showImage(drv, img, dX, dY);
                            } else {
                                scale -= 0.05 * scale;
                            }
                        }
                        if(dir == \'scaledown\') {
                            scale -= 0.05 * scale;
                            if(img.width * scale >= canvas.height || img.width * scale >= canvas.width) {
                                showImage(drv, img, dX, dY);
                            } else {
                                scale += 0.05 * scale;
                            }
                        }
                    });
                };
                img.src = e.target.result;
               
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#imgInp").change(function(){
        readURL(this);
    });

    var timeOutID;
    var offset = 0;
    function showImage(drv, img, x, y) {
        clearTimeout(timeOutID);
        drv.clearRect(0, 0, canvas.width, canvas.height);
        drv.drawImage(img, x, y, img.width * scale, img.height * scale);
        $(\'#img-upload\').attr(\'src\', canvas.toDataURL("image/png"));
        $(\'#img-upload\').attr(\'avatarSelected\', \'yes\');
        drvCircle(drv, img, x, y);
    }

    function drvCircle(drv, img, x, y){
        drv.clearRect(0, 0, canvas.width, canvas.height);
        drv.drawImage(img, x, y, img.width * scale, img.height * scale);        
        offset++;
        if (offset > 60) {
          offset = 0;
        }
        
        drv.beginPath();
        drv.strokeStyle = \'rgba(0, 0, 0, 0.2)\';
        drv.lineWidth = 2;
        drv.setLineDash([]);
        drv.arc(canvas.width / 2, canvas.height / 2, canvas.width /2, 0, Math.PI * 2, true);
        drv.stroke();
        drv.strokeStyle = \'rgba(255, 255, 255, 1)\';
        drv.setLineDash([30, 30]);
        drv.lineDashOffset = -offset;
        drv.arc(canvas.width / 2, canvas.height / 2, canvas.width /2, 0, Math.PI * 2, true);
        drv.stroke();
        drv.beginPath();
        drv.lineWidth = 1;
        drv.strokeStyle = \'rgba(255, 255, 255, 0.75)\';
        drv.setLineDash([]);
        drv.moveTo(0, canvas.height / 2);
        drv.lineTo(canvas.width, canvas.height / 2);
        drv.moveTo(canvas.width / 2, 0);
        drv.lineTo(canvas.width / 2, canvas.height);
        drv.stroke();

        timeOutID = setTimeout(function(){  drvCircle(drv, img, x, y); }, 20);
    }
    $(\'#saveImg\').click(function(){
        $(\'#imgInp\').val(\'\');
        $(\'#img-upload\').attr(\'avatarSelected\', \'yes\');
        $(\'#canvasDiv\').html(\'\');
        $(\'#canvasDiv\').append(\'<canvas id="iCanvas" />\');
        canvas = document.getElementById(\'iCanvas\');
        canvas.width = 0;
        canvas.height = 0;
        drv = canvas.getContext(\'2d\');    
        $(\'#canvasDiv\').css(\'display\', \'none\');
        $(\'#saveImg\').css(\'display\', \'none\');
        $(\'#iTools\').css(\'display\', \'none\');
        $(\'#iTools\').html(\'\');
    });
});

';
$s->{parsed}=join('',@p);
};
1;
