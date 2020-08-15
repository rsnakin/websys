# Generated: Mon Mar 25 20:18:08 2019
#
# This is a compiled version of a FWork Template. Don't make modifications
# to this file, modify the original template instead.
# use utf8;
no warnings; $compiled->{version} = '1.22'; $compiled->{strip_html_comments} = ''; $compiled->{code} = sub {
my $s=shift @_; my $v=$s->{vars}; my @p=(); my $in = $system->in;
push @p,'<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-labelledby="messageModal">
<div class="modal-dialog modal-lg" role="document">
    <div class="modal-content" style="border-radius: 45px 5px 5px 5px">
    <div class="modal-header" id="mHeader" style="padding-bottom:0px">
        <div class="row">
            <div class="col-md-1 col-xs-3"><img src="" class="img-circle" style="width:60px;height:60px;opacity:0;" id="mImg"></div>
            <div class="col-md-10 col-xs-7">
                <a href="" class="nameF" id="mName" style="opacity:0;"></a><br>
                <span id="mStars" style="opacity:0;"></span>
                <div class="metaF" id="mDate" style="opacity:0;"></div>
                <div class="metaUF" id="muDate" style="opacity:0;"></div>
            </div>
            <div class="col-md-1 col-xs-2"><button type="button" class="close" data-dismiss="modal" aria-label="Close" style="outline: 0 !important;border:1px solid #fff;">
                <span aria-hidden="true">&times;</span></button>
            </div>
        </div>
    </div>
    <div class="modal-body" id="messageModalBody" style="word-wrap: break-word;overflow-y: scroll;overflow-x: hidden;">
        
    </div>
    </div>
</div>
</div>
';
$s->{parsed}=join('',@p);
};
1;
