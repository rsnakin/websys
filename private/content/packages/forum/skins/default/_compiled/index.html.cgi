# Generated: Wed May 15 13:14:16 2019
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
    <!-- %include inc/menu.html% -->

    <!-- Begin page content -->

    <div class="container">
      <div class="blog-header">
        <h1 class="blog-title" ><b>Вопрос-Ответ</b></h1>
      </div>
      <!-- <div class="row"> -->
          <!-- <div class="col-md-1"></div>
          <div class="col-md-10" id="neuDivShow" style="padding-left:25px;padding-right:25px;text-align:right;"> -->
            ';if((true($v->{'login'}))){push @p,'
            <!-- <input class="btn myButton" style="outline:none;" id="neuDivShowButton" type="button" value="Добавить сообщение">
            <input class="btn myButton" style="outline:none;" id="logoutButton" type="button" value="Выйти"> -->
            ';}push @p,'
            ';if((false($v->{'login'}))){push @p,'
            <!-- <input class="btn myButton" style="outline:none;" type="button" value="Зарегистрироваться" data-toggle="modal" data-target="#regModal">
            <input class="btn myButton" style="outline:none;" type="button" value="Вход"
            data-toggle="modal" data-target="#loginModal">  -->
            
            ';}push @p,'
          <!-- </div>
          <div class="col-md-1"></div> -->
        <!-- </div> -->
        ';if((true($v->{'login'}))){push @p,'
        <div class="row" id="neuDiv" __style="display:none;opacity:0;">
        <!-- <div class="col-md-1"></div> -->
        <div class="col-md-12">

          <div class="row messageN" id="nMsg" style="padding:15px;opacity:0;">
            <div class="col-md-1 col-xs-2" style="padding:0px;"><img src="';push @p,$v->{'fuser'}->{'avatar'};push @p,'" id="fUserAvatar" class="img-circle img-responsive msgAvatar"></div>
            <div class="col-md-11 col-xs-10"><a href="#" class="nameF">';push @p,$v->{'fuser'}->{'uvorname'};push @p,' ';push @p,$v->{'fuser'}->{'uname'};push @p,'</a><hr style="border-top: 1px dotted#ccc;"></div>
            <div class="col-md-12" style="padding-top:10px;padding-left:5px;padding-right:5px;"><textarea class="textareaClass" id="neuBody" placeholder="Введите текст сообщения"></textarea></div>
            <div class="col-md-12 imagesEditWraper" id="msgUploadWrapper"></div>
            <div class="col-md-9 col-xs-4" style="padding-left:10px;padding-top:10px;display:none;opacity:0;" id="neuSendEmoticonsDiv"></div>
            <div class="col-md-3 col-xs-8" style="text-align:right;padding-right:5px;padding-top:10px;display:none;opacity:0;" id="neuSendButtonDiv">
              <input class="btn myButton1" style="outline:none;" id="neuCancelButton" type="button" value="Отменить">
              <input class="btn myButton" style="outline:none;" id="neuSendButton" type="button" value="Добавить">
            </div>
          </div>

        </div>
        <!-- <div class="col-md-1"></div> -->
      </div>
      ';}push @p,'

      <div _class="row" id="halloDiv" style="display:none;opacity:0;position:absolute;">
        <!-- <div class="col-md-1"></div>
        <div class="col-md-10"> -->

          <div class="row halloMessage">
            <div class="col-md-12" style="text-align: center"><h2>Добро пожаловать </h2><p><h1 style="color:#e95420">';push @p,$v->{'fuser'}->{'uvorname'};push @p,' ';push @p,$v->{'fuser'}->{'uname'};push @p,'!</h1></p></h1></div>
          </div>

        <!-- </div>
        <div class="col-md-1"></div> -->
      </div>

      <div class="row">
        <!-- <div class="col-md-1"></div> -->
        <div class="col-md-12" id="boardDiv"></div>
        <!-- <div class="col-md-1"></div> -->
      </div>
      <div class="row">
        <div class="col-md-12">&nbsp;</div>
        <div class="col-md-12">&nbsp;</div>
        <div class="col-md-12">&nbsp;</div>
        <div class="col-md-12">&nbsp;</div>
      </div>
      </div>
    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

    <!-- ';push @p,$s->{pkg}->_template('inc/message_modal.html')->parse($v);push @p,' -->
    ';if((false($v->{'login'}))){push @p,'
    <!--%include inc/login_modal.html% -->
    <!-- %include inc/reg_modal.html% -->
    ';}push @p,'

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/jquery.min.js"></script>
    <script>window.jQuery || document.write(\'<script src="/js/jquery.min.js"><\\/script>\')</script>
    <script src="/js/bootstrap.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="/js/ie10-viewport-bug-workaround.js"></script>
    <script src="/js/jquery.json.min.js"></script>
    <script src="/js/cookies.js"></script>
    <script src="/js/debug.js"></script>
    <script src="/js/dtools.js?v=';push @p,$v->{'rand'};push @p,'"></script>   
    <!-- <script src="/js/forum/msg.js?v=';push @p,$v->{'rand'};push @p,'"></script> -->
    <script src="/js/forum/emoticons.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <!-- <script src="/js/forum/images.js?v=';push @p,$v->{'rand'};push @p,'"></script> -->
    <!-- <script src="/js/fullscreen.js?v=';push @p,$v->{'rand'};push @p,'"></script> -->
    ';if((false($v->{'login'}))){push @p,'
    <!-- <script src="/js/forum/capcha.js?v=';push @p,$v->{'rand'};push @p,'"></script> -->
    <script src="/js/forum/reg_modal.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    
    ';}push @p,'
    <script src="/js/tooltips.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/menu.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/login.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/main_msg.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/images_show.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/modal_msg.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/msg_page.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/totop.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/main.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/window.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script src="/js/forum/images.js?v=';push @p,$v->{'rand'};push @p,'"></script>
    <script type="text/javascript">
      $(\'#nMsg\').css(\'border-radius\', (parseInt($(\'#fUserAvatar\').width() / 2) + 15) + \'px 5px 5px 5px\');
      $(\'#nMsg\').show().animate({opacity:1}, 500);
    // var pageMenu;
    // jQuery(document).ready(function($){
/*
      if(getBrowser() == \'safari\') {
        loadScript(\'/js/forum/images_safari.js?v=';push @p,$v->{'rand'};push @p,'\');
      } else {
        loadScript(\'/js/forum/images.js?v=';push @p,$v->{'rand'};push @p,'\');
      }
*/
/*
          var waitWindow = new modalWindow({
            content:\'<img src="/i/l.gif" width="32" height="32">\',
            animationSpeed: 100,
            padding:25,
            closeByClick:false,
            closeByESC:false,
            closeButton:false,
            border:0,
            borderRadius:60,
            padding:7
          });
          waitWindow.showWindow();

          setTimeout(function(){
            waitWindow.closeWindow();
          },10000);
*/
    // });
/*
    var newWindow = new modalWindow({
      content:\'<h1>Hallo world!</h1>\',
      animationSpeed: 100,
      padding:25
      // top: 100,
      // left: 100,
      // width:200,
      // height:300
    
    }).showWindow();
*/
    </script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;
