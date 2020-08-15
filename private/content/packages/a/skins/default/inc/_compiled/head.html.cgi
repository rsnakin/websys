# Generated: Sun May 19 15:50:31 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <!-- <link href="https://fonts.googleapis.com/css?family=Comfortaa:300,400,700|Poiret+One" rel="stylesheet"> -->
        <link rel="shortcut icon" type="image/png" href="/i/favicon.png"/>
    
        <title>';push @p,$system->pkg('system')->_config->get('siteTitle');push @p,'</title>
    
        <!-- Bootstrap core CSS -->
        <link href="/css/bootstrap.min.css?test=2" rel="stylesheet">
        <link href="/css/bootstrap-datetimepicker.css" rel="stylesheet">
    
        <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
        <link href="/css/ie10-viewport-bug-workaround.css" rel="stylesheet">
    
        <!-- Custom styles for this template -->
        <link href="/css/sticky-footer-navbar-a.css?test=1" rel="stylesheet">
    
        <!-- Just for debugging purposes. Don\'t actually copy these 2 lines! -->
        <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
        <script src="/js/ie-emulation-modes-warning.js"></script>
    
        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="/js/html5shiv.min.js"></script>
          <script src="/js/respond.min.js"></script>
        <![endif]-->
      </head>
    ';
$s->{parsed}=join('',@p);
};
1;
