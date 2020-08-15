# Generated: Thu Feb 14 16:11:57 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<div id="carousel-index" class="carousel slide" data-ride="carousel">
        <!-- Показатели -->
        <ol class="carousel-indicators">
          ';my $var=$v->{'carousel'};if (ref $var eq 'ARRAY') {my $saved=$v->{'c'};$v->{'c'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'c'}=$element;push @p,'
          <li data-target="#carousel-index" data-slide-to="';push @p,$v->{'c'}->{'cnt'};push @p,'" class="';push @p,$v->{'c'}->{'active'};push @p,'"></li>
          ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'c'}=$saved;}push @p,'
        </ol>
      
        <!-- Обертка для слайдов -->
        <div class="carousel-inner" role="listbox">
          ';my $var=$v->{'carousel'};if (ref $var eq 'ARRAY') {my $saved=$v->{'c'};$v->{'c'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'c'}=$element;push @p,'
          <div class="item ';push @p,$v->{'c'}->{'active'};push @p,'">
            <a href="';push @p,$v->{'c'}->{'url'};push @p,'" class="carousel-link"><img src="';push @p,$v->{'c'}->{'file'};push @p,'" alt="" class="carouselImage"></a>
            <div class="carousel-caption">
              <h1><a href="';push @p,$v->{'c'}->{'url'};push @p,'" class="carousel-link">';push @p,$v->{'c'}->{'name'};push @p,'</a></h1>
            </div>
          </div>
          ';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'c'}=$saved;}push @p,'
        </div>
      
        <!-- Элементы управления -->
        <a class="left carousel-control" href="#carousel-index" role="button" data-slide="prev">
          <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
          <span class="sr-only">Previous</span>
        </a>
        <a class="right carousel-control" href="#carousel-index" role="button" data-slide="next">
          <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
          <span class="sr-only">Next</span>
        </a>
      </div>';
$s->{parsed}=join('',@p);
};
1;
