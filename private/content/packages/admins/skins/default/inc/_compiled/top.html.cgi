# Generated: Tue Oct 17 22:44:42 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<!DOCTYPE html>
<!--[if IE 8]>         <html class="ie8"> <![endif]-->
<!--[if IE 9]>         <html class="ie9 gt-ie8"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="gt-ie8 gt-ie9 not-ie"> <!--<![endif]-->
<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>LENKRAD</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">
</head>
<link rel="stylesheet" href="/a/css/uikit.css" />
<link rel="stylesheet" type="text/css" href="/a/fbox/jquery.fancybox.css?v=2.1.5" media="screen" />
<link rel="stylesheet" type="text/css" href="/a/fbox/helpers/jquery.fancybox-buttons.css?v=1.0.5" />
<link rel="stylesheet" type="text/css" href="/a/fbox/helpers/jquery.fancybox-thumbs.css?v=1.0.7" />
<link rel="stylesheet" type="text/css" href="/a/css/select2.css" rel="stylesheet" />
<body style="background:#ccd0d3;background-image:url(/a/img/bgg.jpg);background-repeat:repeat-x;background-attachment: fixed;">
<div style="background:#000;height:1px;" id="ptop"></div>
<div class="uk-block uk-padding-remove" id="navy" data-uk-sticky="{top:0}" style="z-index:1000">
  <div class="uk-grid" style="background:#000">
    <div class="uk-width-1-10"></div>
      <div class="uk-width-8-10">
        <nav class="uk-navbar" style="background:#000">
          <ul class="uk-navbar-nav"><a href="/" class="uk-navbar-brand uk-animation-scale-up"><img src="/a/img/mdlx.gif"></a>
            <li';if(($v->{'action'} eq 'index')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=index">Главная</a></li>
            <li';if(($v->{'action'} eq 'models')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=models">Модели</a></li>
            <li';if(($v->{'action'} eq 'category')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=category">Каталог</a></li>
            <li';if(($v->{'action'} eq 'mfr')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=mfr">Производители</a></li>
<!--             <li';if(($v->{'action'} eq 'scale')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=scale">Масштаб</a></li> -->
            <li';if(($v->{'action'} eq 'mark')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=mark">Марки</a></li>
            <li';if(($v->{'action'} eq 'titlesbg')){push @p,' class="uk-active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:admins&action=titlesbg">Подложки</a></li>
          </ul>
          <div class="uk-navbar-flip">
            <ul class="uk-navbar-nav">
              <li><a href="/cgi-bin/index.cgi?pkg=content:admins&action=logout">Выход</a></li>
            </ul>
          </div>
        </nav>
      </div>
      <div class="uk-width-1-10"></div>
    </div>
  </div>
</div>
<div style="background:#000;height:1px;"></div>
<div class="uk-block uk-padding-remove" style="height:20px;"></div>
<div class="uk-block uk-padding-remove">
  <div class="uk-grid">
    <div class="uk-width-1-10"></div>
';
$s->{parsed}=join('',@p);
};
1;
