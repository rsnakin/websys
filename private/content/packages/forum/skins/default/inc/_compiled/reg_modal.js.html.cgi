# Generated: Sun Mar 10 20:15:32 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'
var defaultRegItemPic = \'glyphicon glyphicon-asterisk  registerItem\';
var errorRegItemPic = \'glyphicon glyphicon-warning-sign  registerItem\';
var okRegItemPic = \'glyphicon glyphicon-ok registerItem\';

var checkIntervalId;

$(\'#regModal\').on(\'hide.bs.modal\', function (e) {
    if(checkIntervalId) {clearInterval(checkIntervalId); }
    $(\'#iTools\').html(\'\');
    $(\'#canvasDiv\').html(\'\');
    $(\'#captchaDiv\').html(\'\');
    $(\'#img-upload\').attr(\'avatarSelected\', \'no\');
});

$(\'#regModal\').on(\'show.bs.modal\', function (e) {
    $(\'.registerItem\').attr(\'class\', defaultRegItemPic);
    $(\'.form-control\').val(\'\');
    $(\'#sex\').css(\'color\', \'#aaa\');
    $(\'#img-upload\').attr(\'src\', \'/i/a/none.png\');
});

$(\'#regModal\').on(\'shown.bs.modal\', function (e) {
    initCapcha();
    checkIntervalId = setInterval(function(){ validateForm(); }, 500);
});

var waitValidate = false;
function validateForm() {
    if(waitValidate) { return; }
    waitValidate = true;
    var ok = true;
    $(\'.registerItem\').each(function(){
        if($(this).attr(\'class\') != okRegItemPic) {
            ok = false;
            return;
        }
    });
    if(ok) {
        $(\'#regButton\').attr(\'class\', \'btn myButton\');
        $(\'#regButton\').unbind(\'click\');
        $(\'#regButton\').click(function(){
            var regData = {};
            $(\'.form-control\').each(function(){
                var id = this.id;
                if($(this).val()) {
                    regData[id] = $(this).val();
                }
            });
            if($(\'#img-upload\').attr(\'avatarSelected\') == \'yes\') {
                regData[\'avatar\'] = $(\'#img-upload\').attr(\'src\');
            }
            regData[\'captchaCode\'] = captchaCode;

            $.post(
                \'/cgi-bin/index.cgi\', {
                  pkg: \'content:forum\',
                  action: \'registration\',
                  regData: $.toJSON(regData)
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
                  if(response.errors) {
                    if(response.errors.captcha) {
                        $(\'#captchaDiv\').html(\'\');
                        initCapcha();
                        regErrorShow(\'неверно введены символы с картинки!\');
                        $(\'#captcha_pic\').attr(\'class\', errorRegItemPic);
                        $(\'#captcha\').val(\'\');
                        $(\'#captcha\').focus();
                        return;
                    }
                    regErrorShow(\'что-то пошло не так! Попробуйте повторить позже.\');
                    $(\'#captchaDiv\').html(\'\');
                    initCapcha();
                    return;
                  }
                  window.location.href=\'/registration.html\';
                }
            );
        });
    } else {
        $(\'#regButton\').unbind(\'click\');
        $(\'#regButton\').attr(\'class\', \'btn myButtonLock\');
    }
    waitValidate = false;
}

function regErrorShow(text) {
    $(\'#errorDiv\').css(\'display\', \'inline\');
    var o = $(\'#errorDiv\').offset();
    var w = $(\'#errorDiv\').width();
    $(\'#errorDiv\').css(\'position\', \'absolute\');
    $(\'#errorDiv\').offset({top:o.top,left:o.left});
    $(\'#errorDiv\').width(w);
    $(\'#errorText\').html(\'<strong>Ошибка:</strong> \' + text);
    $(\'#errorDiv\').show().animate({opacity:1},1000);
    setTimeout(function(){regErrorHide();}, 5000);
}

function regErrorHide() {
    $(\'#errorDiv\').show().animate({opacity:0},1000);
    setTimeout(function() {
        $(\'#errorDiv\').css(\'display\', \'none\');
        $(\'#errorDiv\').css(\'position\', \'static\');
        $(\'#errorText\').html(\'\');
    }, 1500);
}


$(\'.password_block\').keyup(function(){
    if($(\'#password0\').val().length > 7) {
        if($(\'#password0\').val() == $(\'#password1\').val()) {
            $(\'#password_pic\').attr(\'class\', okRegItemPic);
            $(\'#password_pic1\').attr(\'class\', okRegItemPic);
            $(\'#passwordInfo\').css(\'display\', \'none\');
            $(\'#passwordInfo\').css(\'opacity\', \'0\');
            $(\'#passwordInfo\').html(\'\');
        } else {
            $(\'#passwordInfo\').css(\'display\', \'inline\');
            $(\'#passwordInfo\').css(\'opacity\', \'0\');
            $(\'#passwordInfo\').html(\'Пароли не совпадают!\');
            $(\'#passwordInfo\').show().animate({opacity:1},1000);
            $(\'#password_pic\').attr(\'class\', errorRegItemPic);
            $(\'#password_pic1\').attr(\'class\', errorRegItemPic);
        }
    } else {
        if($(\'#password0\').val().length > 0) {
            // alert(\'11\')
            $(\'#passwordInfo\').css(\'display\', \'inline\');
            $(\'#passwordInfo\').css(\'opacity\', \'0\');
            $(\'#passwordInfo\').html(\'Слишком короткий пароль!\');
            $(\'#passwordInfo\').show().animate({opacity:1},1000);
            $(\'#password_pic\').attr(\'class\', errorRegItemPic);
            $(\'#password_pic1\').attr(\'class\', errorRegItemPic);
        } else {
            $(\'#password_pic\').attr(\'class\', defaultRegItemPic);
            $(\'#password_pic1\').attr(\'class\', defaultRegItemPic);
            $(\'#passwordInfo\').css(\'display\', \'none\');
            $(\'#passwordInfo\').css(\'opacity\', \'0\');
            $(\'#passwordInfo\').html(\'\');
        }
    }
});

$(\'#captcha\').keyup(function(){
    if($(this).val().length >= 6) {
        $(\'#\' + this.id + \'_pic\').attr(\'class\', okRegItemPic);
    } else {
        $(\'#\' + this.id + \'_pic\').attr(\'class\', errorRegItemPic);
    }
});

$(\'.name_block\').keyup(function(){
    var tid = this.id;
    if($(this).val().length > 0) {
        $(\'#\' + tid + \'_pic\').attr(\'class\', okRegItemPic);
    } else {
        $(\'#\' + tid + \'_pic\').attr(\'class\', errorRegItemPic);
    }
});
$(\'#sex\').change(function(){
    if($(\'#img-upload\').attr(\'avatarSelected\') == \'yes\') { 
        if($(\'#sex\').val()) {
            $(\'#sex_pic\').attr(\'class\', okRegItemPic);
        } else {
            $(\'#sex_pic\').attr(\'class\', errorRegItemPic);
        }
        return; 
    }
    if($(\'#sex\').val()) {
        $(\'#sex_pic\').attr(\'class\', okRegItemPic);
        $(\'#sex\').css(\'color\', \'#000\');
        $(\'#img-upload\').css(\'opacity\', \'0\');
        if($(\'#sex\').val() == \'1\') {
            $(\'#img-upload\').attr(\'src\', \'/i/a/male.png\');
        } else {
            $(\'#img-upload\').attr(\'src\', \'/i/a/female.png\');
        }
        $(\'#img-upload\').show().animate({opacity:1},1000);
    } else {
        $(\'#sex_pic\').attr(\'class\', errorRegItemPic);
        $(\'#img-upload\').attr(\'src\', \'/i/a/none.png\');
        $(\'#sex\').css(\'color\', \'#aaa\');
    }
});

$(\'#email\').keyup(function(){
    if($(\'#email\').val().length > 0) {
        if(validateEmail($(\'#email\').val())) {
            checkEmail($(\'#email\').val());
        } else {
            $(\'#email_pic\').attr(\'class\', errorRegItemPic);
            $(\'#emailInfo\').css(\'display\', \'inline\');
            $(\'#emailInfo\').css(\'opacity\', \'0\');
            $(\'#emailInfo\').html(\'Неверный адрес <strong>\' + $(\'#email\').val() + \'</strong>\');
            $(\'#emailInfo\').show().animate({opacity:1},1000);
        }
    } else {
        $(\'#email_pic\').attr(\'class\', errorRegItemPic);
        $(\'#emailInfo\').css(\'display\', \'none\');
        $(\'#emailInfo\').css(\'opacity\', \'0\');
        $(\'#emailInfo\').html(\'\');
    }
});

$(\'#ulogin\').keyup(function(){
    if($(\'#ulogin\').val().length > 5) {
        checkLogin($(\'#ulogin\').val());
    } else {
        if($(\'#ulogin\').val().length > 0) {
            $(\'#login_pic\').attr(\'class\', errorRegItemPic);
            $(\'#loginInfo\').css(\'display\', \'inline\');
            $(\'#loginInfo\').css(\'opacity\', \'0\');
            $(\'#loginInfo\').html(\'Логин <strong>\' + $(\'#ulogin\').val() + \'</strong> слишком короткий!\');
            $(\'#loginInfo\').show().animate({opacity:1},1000);
        } else {
            $(\'#login_pic\').attr(\'class\', errorRegItemPic);
            $(\'#loginInfo\').css(\'display\', \'none\');
            $(\'#loginInfo\').css(\'opacity\', \'0\');
            $(\'#loginInfo\').html(\'\');
        }
    }
});


function validateEmail(email) {
    var re = /^(([^<>()[\\]\\\\.,;:\\s@\\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\\"]+)*)|(\\".+\\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

var lemail;
var lstatus;
function checkEmail(email) {
    if(lemail == email) {
        if(lstatus) {
            $(\'#email_pic\').attr(\'class\', okRegItemPic);
        } else {
            $(\'#email_pic\').attr(\'class\', errorRegItemPic);
            $(\'#emailInfo\').css(\'display\', \'inline\');
            $(\'#emailInfo\').css(\'opacity\', \'0\');
            $(\'#emailInfo\').html(\'Адрес <strong>\' + email + \'</strong> уже зарегистрирован!\');
            $(\'#emailInfo\').show().animate({opacity:1},1000);
        }
        return;
    }
    $.post(
        \'/cgi-bin/index.cgi\', {
          pkg: \'content:forum\',
          action: \'check_email\',
          email: email
        },
        function(data, textStatus){
          var response;
          try {
            response = $.evalJSON(data);
          }
          catch(e) {
            $(\'#emailInfo\').css(\'display\', \'inline\');
            $(\'#emailInfo\').css(\'opacity\', \'0\');
            $(\'#emailInfo\').html(\'Системная ошибка (\' + e + \')\');
            $(\'#emailInfo\').show().animate({opacity:1},1000);
            lemail = email; lstatus = false;
            $(\'#email_pic\').attr(\'class\', errorRegItemPic);
          } 
          if($.evalJSON(data).status == \'exists\') {
            $(\'#emailInfo\').css(\'display\', \'inline\');
            $(\'#emailInfo\').css(\'opacity\', \'0\');
            $(\'#emailInfo\').html(\'Адрес <strong>\' + email + \'</strong> уже зарегистрирован!\');
            $(\'#emailInfo\').show().animate({opacity:1},1000);
            lemail = email; lstatus = false;
            $(\'#email_pic\').attr(\'class\', errorRegItemPic);
          } else {
            $(\'#emailInfo\').css(\'display\', \'none\');
            $(\'#emailInfo\').html(\'\');
            lemail = email; lstatus = true;
            $(\'#email_pic\').attr(\'class\', okRegItemPic);
          }
        }
      );
}

var llogin;
var llstatus;
function checkLogin(ulogin) {
    // alert(llogin + \' \' + ulogin);
    if(llogin == ulogin) {
        if(llstatus) {
            $(\'#login_pic\').attr(\'class\', okRegItemPic);
            $(\'#loginInfo\').css(\'display\', \'none\');
            $(\'#loginInfo\').html(\'\');
        } else {
            $(\'#login_pic\').attr(\'class\', errorRegItemPic);
            $(\'#loginInfo\').css(\'display\', \'inline\');
            $(\'#loginInfo\').css(\'opacity\', \'0\');
            $(\'#loginInfo\').html(\'Логин \' + ulogin + \' уже зарегистрирован!\');
            $(\'#loginInfo\').show().animate({opacity:1},1000);
        }
        return;
    }
    // alert(llogin + \' -- \' + ulogin);
    $.post(
        \'/cgi-bin/index.cgi\', {
          pkg: \'content:forum\',
          action: \'check_login\',
          login: ulogin
        },
        function(data, textStatus){
          var response;
          try {
            response = $.evalJSON(data);
          }
          catch(e) {
            $(\'#loginInfo\').css(\'display\', \'inline\');
            $(\'#loginInfo\').css(\'opacity\', \'0\');
            $(\'#loginInfo\').html(\'Системная ошибка (\' + e + \')\');
            $(\'#loginInfo\').show().animate({opacity:1},1000);
            llogin = ulogin; llstatus = false;
            $(\'#login_pic\').attr(\'class\', errorRegItemPic);
          } 
          if($.evalJSON(data).status == \'exists\') {
            $(\'#loginInfo\').css(\'display\', \'inline\');
            $(\'#loginInfo\').css(\'opacity\', \'0\');
            $(\'#loginInfo\').html(\'Логин <strong>\' + ulogin + \'</strong> уже зарегистрирован!\');
            $(\'#loginInfo\').show().animate({opacity:1},1000);
            llogin = ulogin; llstatus = false;
            $(\'#login_pic\').attr(\'class\', errorRegItemPic);
          } else {
            $(\'#loginInfo\').css(\'display\', \'none\');
            $(\'#loginInfo\').html(\'\');
            llogin = ulogin; llstatus = true;
            $(\'#login_pic\').attr(\'class\', okRegItemPic);
          }
        }
      );
}
';
$s->{parsed}=join('',@p);
};
1;
