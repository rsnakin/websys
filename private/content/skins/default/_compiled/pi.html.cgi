# Generated: Thu Oct  3 22:21:43 2019
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
<!--     <include inc/menu.html> -->
    <div class="container">
      <div class="row">
<!--         <div class="col-md-2"><b>Temperatur</b> <span id="temperatur">...loading...</span></div> -->
        <div class="col-md-12" style="padding:0px" id="canvasDiv"><canvas id="show_temp"></div>
      </div>
      <div class="row">
        <div class="col-md-12" id="debug"></div>
      </div>
    </div>

<!--     hallo! <include inc/footer.html> -->

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
        var counter = 0;
        var breit = 2;
        var canvas = document.getElementById(\'show_temp\');
        canvas.width = $(\'#canvasDiv\' ).width();
        canvas.height = parseInt(canvas.width / 2);
        var limit = parseInt(canvas.width / breit) - 1;
        var scale = canvas.height / 150;
        var drv = canvas.getContext(\'2d\');
        
        getData(limit);
        setInterval(function(){
            getData();
        }, 10000);
        
        var img;
        function draw() {
          if(!img) {
            img = new Image();
            img.onload = function(){
              drv.drawImage(img, 0, 0, 400, 475, canvas.width - 510, 15,  400 * .25, 475 * .25);
            };
            img.src = \'/i/rpi.jpg\';
          } else {
            drv.drawImage(img, 0, 0, 400, 475, canvas.width - 510, 15,  400 * .25, 475 * .25);
          }
        }
        
        function skala() {
            drv.lineWidth = 1;
            for (i = canvas.width; i > 1; ) {
              drv.strokeStyle = "rgba(255, 255, 255, .5)";
              drv.lineWidth = .5;
              drv.beginPath();
              drv.moveTo(i, 0);
              drv.lineTo(i, canvas.height);
              drv.stroke();
              drv.strokeStyle = "rgba(128, 128, 128, .5)";
              drv.lineWidth = .5;
              drv.beginPath();
              drv.moveTo(i, 0);
              drv.lineTo(i, canvas.height);
              drv.stroke();
              i = i - canvas.width / limit * 25;
//               $(\'#debug\').append(i + \'  \');
            }
            for (i = 0; i < 150; ) {
              drv.strokeStyle = "rgba(255, 255, 255, .5)";
              drv.lineWidth = .5;
              drv.beginPath();
              drv.moveTo(0, i * scale);
              drv.lineTo(canvas.width, i * scale);
              drv.stroke();
              drv.strokeStyle = "rgba(128, 128, 128, .5)";
              drv.lineWidth = .5;
              drv.beginPath();
              drv.moveTo(0, i * scale);
              drv.lineTo(canvas.width, i * scale);
              drv.stroke();
              i = i +10;
              drv.fillStyle = "rgba(255, 255, 255, 1)";
              drv.font = "17px Sans-serif";
              drv.fillText(150 - i, 10, i * scale - 5);
              drv.fillStyle = "rgba(128, 128, 128, .5)";
              drv.font = "17px Sans-serif";
              drv.fillText(150 - i, 10, i * scale - 5);
            }
            drv.strokeStyle = "rgba(128, 128, 128, 1)";
            drv.lineWidth = 1;
            drv.beginPath();
            drv.moveTo(1, 1);
            drv.lineTo(1, canvas.height - 1);
            drv.lineTo(canvas.width - 1, canvas.height - 1);
            drv.lineTo(canvas.width - 1, 1);
            drv.lineTo(1, 1);
            drv.stroke();
        }
        
        function show_picture(temp) {
            drv.fillStyle = "white";
            drv.fillRect(canvas.width - (counter + 1) * breit, 0, breit, canvas.height);
            drv.fillStyle = "green";
          
             if(temp > 69) {
                drv.fillStyle = "red";
            }
            drv.fillRect(canvas.width - (counter + 1) * breit, canvas.height - temp * scale, breit, canvas.height - temp);
            counter ++;
        }
        
        function getData(limit) {
//             drv.fillStyle = "white";
//             drv.clearRect(0, 0, canvas.width, canvas.height);
            counter = 0;
            $.post(
                \'/cgi-bin/index.cgi\', {
                    pkg: \'content\',
                    action: \'pi_data\',
                    limit: limit
                },
                function(data, textStatus){
                    var linies;
                    try {
                        linies = $.evalJSON(data);
                    }
                    catch(e) {
                        alert("Error");
                        return;
                    } 
                    show_picture(linies[\'temp\']);
                    for (var i in linies[\'linies\']) {
                      show_picture(linies[\'linies\'][i][\'pi_temp\']);
                    }
                    skala();
                    if(linies[\'temp\']) {
//                       $(\'#temperatur\').html(linies[\'temp\'] + \'&deg\');
                        drv.fillStyle = "rgba(64, 64, 64, 1)";
                        drv.font = "25px Sans-serif";
                        drv.fillText(linies[\'hostname\'], canvas.width - 400, 40);
                        drv.fillText(linies[\'date\'], canvas.width - 400, 70);
                        drv.fillText(\'Temperatur:\', canvas.width - 400, 100);
                        drv.fillStyle = "green";
                        if(linies[\'temp\'] > 69) {
                          drv.fillStyle = "red";
                        }
                        drv.fillText(linies[\'temp\'], canvas.width - 260, 100);
                        draw();
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
