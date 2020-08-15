# Generated: Tue Mar 12 23:13:21 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="messageModal">
    <div class="modal-dialog" role="document">
      <div class="modal-content" style="border-radius: 45px 5px 5px 5px">
        <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="outline: 0 !important;border:1px solid #fff;"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-log-in" aria-hidden="true"></span> Авторизация</h4>
        </div>
        <div class="modal-body" style="background:#e95420">
          <div class="row">
            <div class="col-md-12" style="padding: 5px;"><input type="login" class="form-control" id="login" placeholder="Логин" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-12" style="padding: 5px;"><input type="password" class="form-control" id="password" placeholder="Пароль" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-12" style="padding: 5px;display:none;opacity:0;" id="loginErrorDiv">
              <div id="loginErrorText"></div>
            </div>
        </div>
        </div>
        <div class="modal-footer" _style="background:#e95420">
          <div class="row">
              <div class="col-md-4 col-xs-6" style="text-align:left"><button type="button" class="btn myButton1" id="forgetPassword">Забыл пароль?</button></div>
              <div class="col-md-8 col-xs-6">
                <button type="button" class="btn myButton1" data-dismiss="modal" id="closeDialog">Закрыть</button>
                <button type="button" class="btn myButton" id="loginButton">Войти</button>
              </div>
          </div>
        </div>
      </div>
    </div>
  </div>
';
$s->{parsed}=join('',@p);
};
1;
