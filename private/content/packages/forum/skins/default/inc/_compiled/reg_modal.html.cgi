# Generated: Tue Mar 12 23:12:43 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<div class="modal fade" id="regModal" tabindex="-1" role="dialog" aria-labelledby="regModal">
    <div class="modal-dialog" role="document">
      <div class="modal-content" style="border-radius: 45px 5px 5px 5px">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="outline: 0 !important;border:1px solid #fff;"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-check" aria-hidden="true"></span> Регистрация</h4>
        </div>
        <div class="modal-body" style="background:#e95420">
          <div class="row">
            <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="text" class="form-control name_block" tabindex="1" id="vorname" placeholder="Имя" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;color:#fff"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="vorname_pic"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="text" class="form-control name_block" tabindex="2" id="name" placeholder="Фамилия" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="name_pic"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 5px;"><select class="form-control" tabindex="3" id="sex" style="outline: 0 !important;border:1px solid #e95420;color:#aaa">
              <option value="">Укажите пол</option>
              <option value="0">Женский</option>
              <option value="1">Мужской</option>
            </select>
            </div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="sex_pic"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="text" class="form-control" tabindex="4" id="email" placeholder="E-mail" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="email_pic"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 15px;display:none;color: #fff" id="emailInfo"></div><div class="col-md-1 col-xs-2" style="padding: 5px;display:none;"></div>
            <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="login" class="form-control" tabindex="5" id="ulogin" placeholder="Логин" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="login_pic"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 15px;display:none;color: #fff" id="loginInfo"></div><div class="col-md-1 col-xs-2" style="padding: 5px;display:none;"></div>
                <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="password" class="form-control password_block" tabindex="6" id="password0" placeholder="Пароль" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="password_pic"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="password" class="form-control password_block" tabindex="7" id="password1" placeholder="Повторите пароль" style="outline: 0 !important;border:1px solid #e95420;"></div>
            <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="registerItem" aria-hidden="true" id="password_pic1"></span></button></div>
            <div class="col-md-11 col-xs-10" style="padding: 15px;display:none;color: #fff" id="passwordInfo"></div><div class="col-md-1 col-xs-2" style="padding: 5px;display:none;"></div>

            <div class="col-md-10 col-xs-10" style="padding: 5px;">
                <div class="input-group">
                    <span class="input-group-btn">
                        <span class="btn myButton1 btn-file">
                            Выбрать аватар <input type="file" id="imgInp" accept="image/*">
                        </span>
                    </span>
                    <input type="text" id="textImgInp" class="form-control" tabindex="8" readonly style="color:#aaa;border:1px solid #e95420;border-radius: 5px;background: #fff;outline: 0 !important;">
                    <span class="input-group-btn">
                      <span class="btn myButton1" style="display: none" id="saveImg">
                          Применить
                      </span>
                  </span>
                </div>
              </div>
              <div class="col-md-2 col-xs-2" style="padding: 5px;text-align: center;border-radius:5px;"><img src="/i/a/none.png" id="img-upload" class="img-responsive img-circle"></div>
              <div class="col-md-10 col-xs-10" style="padding: 5px;cursor:move;display:none;" id="canvasDiv"></div>
              <div class="col-md-2 col-xs-2" style="padding: 5px;color:#fff;text-align: center;display:none" id="iTools"></div>
              <div class="col-md-11 col-xs-10" style="padding: 5px;color:#fff;text-align:center;" id="captchaDiv"></div>
              <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                <span class="glyphicon glyphicon-refresh" aria-hidden="true" id="captcha_refresh" style="cursor: pointer"></span></button></div>
              <div class="col-md-11 col-xs-10" style="padding: 5px;"><input type="text" class="form-control" tabindex="8" id="captcha" placeholder="Введите текст с картинки" style="outline: 0 !important;border:1px solid #e95420;"></div>
              <div class="col-md-1 col-xs-2" style="padding: 5px;"><button type="button" class="btn regIcon" tabindex="-1">
                  <span class="registerItem" aria-hidden="true" id="captcha_pic"></span></button></div>
              <div class="col-md-12 col-xs-12" style="padding:5px;display:none;opacity:0;" id="errorDiv">
                <div id="errorText"></div>
              </div>
          </div>
        </div>
        <div class="modal-footer" _style="background:#e95420">
          <div class="row">
              <div class="col-md-12">
                <button type="button" class="btn myButton1" data-dismiss="modal" id="closeDialog" tabindex="10">Отменить</button>
                <button type="button" class="btn myButtonLock" id="regButton" tabindex="9">Зарегистрироваться</button>
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
