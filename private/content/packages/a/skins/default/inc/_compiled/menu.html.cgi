# Generated: Sun Feb 10 19:25:36 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" style="font-size: 20px;font-style: oblique;font-weight: bold;" href="/a"><span class="glyphicon glyphicon-leaf"></span></a>
    </div>
    <div id="navbar" class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
        <li';if(($v->{'page'} eq 'index')){push @p,' class="active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:a&action=index">Рубрикатор</a></li>
        <li';if(($v->{'page'} eq 'issues')){push @p,' class="active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:a&action=issues">Статьи</a></li>
        <li';if(($v->{'page'} eq 'carousel')){push @p,' class="active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:a&action=carousel">Карусель</a></li>
        <li';if(($v->{'page'} eq 'front')){push @p,' class="active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:a&action=front">Фронт</a></li>
        <li';if(($v->{'page'} eq 'cache')){push @p,' class="active"';}push @p,'><a href="/cgi-bin/index.cgi?pkg=content:a&action=cache">Кэшь</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="/cgi-bin/index.cgi?pkg=content:a&action=logout">Выход</a></li>
      </ul>
      <!-- <form class="navbar-form navbar-right">
        <input type="text" class="form-control" placeholder="Search...">
      </form> -->
    </div><!--/.nav-collapse -->
  </div>
</nav>
  ';
$s->{parsed}=join('',@p);
};
1;
