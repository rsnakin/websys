# Generated: Sun Mar 10 22:19:48 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'
$(\'#loginButton\').click(function(){
    if($(\'#login\').val().length < 6) {
        loginErrorShow(\'неверный логин или пароль!\');
        return;
    }
    if($(\'#password\').val().length < 8) {
        loginErrorShow(\'неверный логин или пароль!\');
        return;
    }
    var loginData = {};
    loginData[\'login\'] = $(\'#login\').val();
    loginData[\'password\'] = $(\'#password\').val();
    infoShow(\'Передаю данные...\');
    $.post(
        \'/cgi-bin/index.cgi\', {
          pkg: \'content:forum\',
          action: \'login\',
          loginData: $.toJSON(loginData)
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
            if(response.error) {
                loginErrorShow(\'неверный логин или пароль!\');
                return;
            }
            if(response.ok) {
                window.location.href=\'/forum\';
            }
        }
    );

});

$(\'#loginModal\').keyup(function(e){
    if(e.which == 13) {
        $(\'#loginButton\').trigger(\'click\');
    }
});

function infoShow(text) {
    $(\'#loginErrorDiv\').css(\'display\', \'inline\');
    var o = $(\'#loginErrorDiv\').offset();
    var w = $(\'#loginErrorDiv\').width();
    $(\'#loginErrorDiv\').css(\'position\', \'absolute\');
    $(\'#loginErrorDiv\').offset({top:o.top,left:o.left});
    $(\'#loginErrorDiv\').width(w);
    $(\'#loginErrorText\').css(\'color\', \'#00ee00\');
    $(\'#loginErrorText\').html(text);
    $(\'#loginErrorDiv\').show().animate({opacity:1},1000);
    setTimeout(function(){loginErrorHide();}, 5000);
}

function loginErrorShow(text) {
    $(\'#loginErrorDiv\').css(\'display\', \'inline\');
    var o = $(\'#loginErrorDiv\').offset();
    var w = $(\'#loginErrorDiv\').width();
    $(\'#loginErrorDiv\').css(\'position\', \'absolute\');
    $(\'#loginErrorDiv\').offset({top:o.top,left:o.left});
    $(\'#loginErrorDiv\').width(w);
    $(\'#loginErrorText\').css(\'color\', \'#ee0000\');
    $(\'#loginErrorText\').html(\'<strong>Ошибка:</strong> \' + text);
    $(\'#loginErrorDiv\').show().animate({opacity:1},1000);
    setTimeout(function(){loginErrorHide();}, 5000);
}

function loginErrorHide() {
    $(\'#loginErrorDiv\').show().animate({opacity:0},1000);
    setTimeout(function() {
        $(\'#loginErrorDiv\').css(\'display\', \'none\');
        $(\'#loginErrorDiv\').css(\'position\', \'static\');
        $(\'#loginErrorText\').html(\'\');
    }, 1500);
}

$(\'#loginModal\').on(\'show.bs.modal\', function (e) {
    $(\'#login\').val(\'\');
    $(\'#password\').val(\'\');
});
';
$s->{parsed}=join('',@p);
};
1;
