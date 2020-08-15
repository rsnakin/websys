# Generated: Wed Jan 30 17:06:28 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'
<!DOCTYPE html>
<html lang="ru">
    ';push @p,$s->{pkg}->_template('inc/head_public.html')->parse($v);push @p,'
    ';push @p,$s->{pkg}->_template('inc/style.html')->parse($v);push @p,'
    <body>

    <!-- Fixed navbar -->
    ';push @p,$s->{pkg}->_template('inc/menu.html')->parse($v);push @p,'

    <!-- Begin page content -->
    <div class="container">
  
        <div class="row">
  
          <div class="col-sm-12 blog-main">
              <div class="blog-header">
                  <h2 class="blog-title">';push @p,$v->{'i'}->{'name'};push @p,'</h2>
                  <p class="blog-post-meta"></p>
                  <p class="blog-post-meta">';push @p,$v->{'i'}->{'date_time'};push @p,'</p>
                </div>
          
            <div class="blog-post">
              ';push @p,$v->{'i'}->{'body'};push @p,'<p>&nbsp;</p>
            </div><!-- /.blog-post -->
          </div><!-- /.blog-main -->
  
          
  
        </div><!-- /.row -->
      </div>
    ';push @p,$s->{pkg}->_template('inc/footer.html')->parse($v);push @p,'

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/jquery.min.js"></script>
    <script>window.jQuery || document.write(\'<script src="/js/jquery.min.js"><\\/script>\')</script>
    <script src="/js/bootstrap.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="/js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
';
$s->{parsed}=join('',@p);
};
1;
