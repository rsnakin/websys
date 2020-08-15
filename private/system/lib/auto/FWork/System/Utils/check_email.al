# NOTE: Derived from /www/cgi-bin/private/system/lib/FWork/System/Utils.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package FWork::System::Utils;

#line 205 "/www/cgi-bin/private/system/lib/FWork/System/Utils.pm (autosplit into lib/auto/FWork/System/Utils/check_email.al)"
sub check_email { ($_[0] || return) =~ /^[^\@\s,;]+\@[^\.\s,;]+\.[^\s,;]+$/ }


# end of FWork::System::Utils::check_email
1;
