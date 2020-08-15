# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 819 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/strip_js_comments.al)"
sub strip_js_comments {
  my $content = shift;
  return $content if false($content);

  # only remove JS comments, correctly doesn't remove //--> (requires $1$2$3 substitution)
  # $content should only have the JS code for this regexp to work correctly
  my $js_comments = qr!
    (
        [^"'/]+ |
        (?:"[^"\\]*(?:\\.[^"\\]*)*"[^"'/]*)+ |
        (?:'[^'\\]*(?:\\.[^'\\]*)*'[^"'/]*)+
    ) |
    
    (//\s*-->) |
    
    /
    (?:
      \*[^*]*\*+ (?: [^/*][^*]*\*+ )*/\s*\n?\s* |
      /[^\n]*(\n|$)
    )
  !xo;  
  
  $content =~ s/$js_comments/$1$2$3/sg;
  
  return $content;
}

# end of FWork::System::Utils::strip_js_comments
1;
