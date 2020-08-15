# Generated: Sat Oct 14 12:19:45 2017
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<div class="uk-block uk-padding-remove">
<div class="uk-grid">
';my $var=$v->{'images'};if (ref $var eq 'ARRAY') {my $saved=$v->{'i'};$v->{'i'}=undef;if (ref $var->[0]) {$var->[0]->{loop_first}=1;$var->[$#$var]->{loop_last}=1;}my $counter=0;foreach my $element (@$var){$element->{loop_odd}=1 if ref $element and ++$counter%2;$element->{loop_idx}=$counter if ref $element;$v->{'i'}=$element;push @p,'  <div class="uk-width-2-10" style="">
    <table>
      <tr>
        <td style="border-left:1px dotted #888;border-top:1px dotted #888;border-bottom:1px dotted #888"><a href="';push @p,$v->{'base_url'};push @p,'/';push @p,$v->{'i'}->{'image_name'};push @p,'/a.jpg" class="_images" rel="imggroup"><img src="';push @p,$v->{'base_url'};push @p,'/';push @p,$v->{'i'}->{'image_name'};push @p,'/c.jpg"></a></td>
        <td valign="top" style="border-right:1px dotted #888;border-top:1px dotted #888;border-bottom:1px dotted #888">
          <div class="remove_img" imgid="';push @p,$v->{'i'}->{'image_name'};push @p,'" style="font-size: 1.2em;cursor:pointer;color:#cc0000">X</div>
          <div class="sort_img" direct="up" imgid="';push @p,$v->{'i'}->{'image_name'};push @p,'" style="font-size: 2em;cursor:pointer">&laquo;</div>
          <div class="sort_img" direct="down" imgid="';push @p,$v->{'i'}->{'image_name'};push @p,'" style="font-size: 2em;cursor:pointer">&raquo;</div>
        </td>
      </tr>
    </table>
  </div>
';}if (ref $var->[0]) {delete $var->[0]->{loop_first};delete $var->[$#$var]->{loop_last};}$v->{'i'}=$saved;}push @p,'</div>
</div>
<script type="text/javascript">
  $(\'.remove_img\').click(function(){
    var imgid = $(this).attr(\'imgid\');
    if(confirm(\'Удалить изображение\')) {
      $.post(
        \'/cgi-bin/index.cgi\',
        {
          pkg: \'content:admins\',
          action: \'get_images\',
          remove: \'yes\',
          image_name: imgid,
          model_id: ';push @p,($ndCH=$in->query('model_id'));push @p,'
        },
        function(data, textStatus){
          var images = jQuery.parseJSON(data);
          if(!images[\'html\']) {
            $(\'#iset\').css(\'display\', \'block\');
            $(\'#iset\').html(\'<div style="display:inline">Нет изображений</div>\');
          } else {
            $(\'#iset\').css(\'display\', \'block\');
            $(\'#iset\').html(images[\'html\']);
          }
        }
      );      
    }
  });
  $(\'.sort_img\').click(function(){
    var imgid = $(this).attr(\'imgid\');
    var direct = $(this).attr(\'direct\');
    $.post(
      \'/cgi-bin/index.cgi\',
      {
        pkg: \'content:admins\',
        action: \'get_images\',
        sort: \'yes\',
        image_name: imgid,
        direct: direct,
        model_id: ';push @p,$ndCH;push @p,'
      },
      function(data, textStatus){
        var images = jQuery.parseJSON(data);
        if(!images[\'html\']) {
          $(\'#iset\').css(\'display\', \'block\');
          $(\'#iset\').html(\'<div style="display:inline">Нет изображений</div>\');
        } else {
          $(\'#iset\').css(\'display\', \'block\');
          $(\'#iset\').html(images[\'html\']);
        }
      }
    );      
  });
  $("a._images").fancybox({
    helpers: {
      overlay: {
        locked: false
      }
    },
    \'transitionIn\'  :       \'elastic\',
    \'transitionOut\' :       \'elastic\',
    \'speedIn\'       :       600, 
    \'speedOut\'      :       200, 
    \'overlayShow\'   :       false
  });
</script>';
$s->{parsed}=join('',@p);
};
1;
