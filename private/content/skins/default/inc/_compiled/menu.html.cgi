# Generated: Wed Jun  3 19:54:33 2020
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
            <a class="navbar-brand" style="font-size: 20px;font-weight: bold;font-family: \'Comfortaa\', cursive;" href="/">';push @p,$system->pkg('system')->_config->get('siteName');push @p,'</a>
          </div>
          <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
              ';my $var=$v->{'menu'};if (ref $var eq 'ARRAY') {my $saved=$v->{'m'};$v->{'m'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'m'}=$element;push @p,'
                ';if((false($v->{'m'}->{'items'}))){push @p,'
                  <li ';if(($v->{'page'} eq $v->{'m'}->{'path'})){push @p,' class="active"';}push @p,'><a href="';push @p,$v->{'m'}->{'path'};push @p,'">';push @p,$v->{'m'}->{'name'};push @p,'</a></li>
                ';}push @p,'
                ';if((true($v->{'m'}->{'items'}))){push @p,'
                  <li class="dropdown';if(($v->{'page'} eq $v->{'m'}->{'path'})){push @p,' active';}push @p,'">
                      <a href="" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">';push @p,$v->{'m'}->{'name'};push @p,'<span class="caret"></span></a>
                      <ul class="dropdown-menu">
                        ';my $var=$v->{'m'}->{'items'};if (ref $var eq 'ARRAY') {my $saved=$v->{'i'};$v->{'i'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'i'}=$element;push @p,'
                          <li><a href="';push @p,$v->{'i'}->{'path'};push @p,'">';push @p,$v->{'i'}->{'name'};push @p,'</a></li>
                        ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'i'}=$saved;}push @p,'
                      </ul>
                  </li>
                ';}push @p,'
              ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'m'}=$saved;}push @p,'
              
            </ul>
            <!-- <ul class="nav navbar-nav navbar-right">
                <li><a href="#"><span class="glyphicon glyphicon-search"></span></a></li>
            </ul> -->
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
