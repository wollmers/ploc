use strict;
use warnings;

use utf8;
use lib "../lib";

use open        qw< :std  :utf8     >;

use Test::More;   # see done_testing()

my $module = 'ShareFix::I18N';

BEGIN { 
    use_ok( 'ShareFix::I18N' );
    use_ok('Locales'); 
}

can_ok($module, qw < 
new
get_local_handle
code2country
code2language
locale
languageCode
select_plural_form
plural_form_categories
format_decimal
_check_locale
_decode
>);



my @locales = qw < de de_DE de_de de-DE de-Latn-spelling1996 de-de de_AT en en_US fr ru xy >;

is(ShareFix::I18N::_check_locale('de'),'de', "is 'de'");    
is(ShareFix::I18N::_check_locale('DE'),'de', "is 'DE -> de'");
is(ShareFix::I18N::_check_locale('de_DE'),'de', "is 'de_DE -> de'");
is(ShareFix::I18N::_check_locale('de-DE'),'de', "is 'de-DE -> de'");
is(ShareFix::I18N::_check_locale('de-AT'),'de_at', "is 'de-AT -> de_at'");
is(ShareFix::I18N::_check_locale('de_AT'),'de_at', "is 'de_AT -> de_at'");
is(ShareFix::I18N::_check_locale('de_at'),'de_at', "is 'de_at -> de_at'");
is(ShareFix::I18N::_check_locale('DE_AT'),'de_at', "is 'DE_AT -> de_at'");
is(ShareFix::I18N::_check_locale('xy'),'en', "is 'xy -> en'");



for my $locale ( @locales ) {
    my $handle;
    ok($handle = ShareFix::I18N->new($locale), "ShareFix::I18N->new $locale");
    isa_ok($handle->get_local_handle(), 'Locales');     
}

my $country_names = {
    de => { 
        de => 'Deutschland',
        at => 'Österreich',
    },  
    en => { 
        de => 'Germany',
        at => 'Austria',
    },       
};

for my $lang ( keys %{$country_names} ) {
    my $handle;
    ok($handle = ShareFix::I18N->new($lang), "new $lang");
    isa_ok($handle->get_local_handle(), 'Locales');
    for my $code (keys %{$country_names->{$lang}}) {
        is($handle->code2country($code),$country_names->{$lang}->{$code},"$lang code2country $code");
    }     
}

my $language_names = {
    de => { 
        de => 'Deutsch',
        ru => 'Russisch',
        es => 'Spanisch',
    },  
    en => { 
        de => 'German',
        ru => 'Russian',
        es => 'Spanish',
    },
    ru => { 
        de => 'немецкий',
        ru => 'русский',
        es => 'испанский',
    },       
};

for my $lang ( keys %{$language_names} ) {
    my $handle;
    ok($handle = ShareFix::I18N->new($lang), "new $lang");
    isa_ok($handle->get_local_handle(), 'Locales');
    for my $code (keys %{$language_names->{$lang}}) {
        is($handle->code2language($code),$language_names->{$lang}->{$code},"$lang code2language $code");
    }     
}

# locale()
{
    my $handle;
    my $lang = 'de_at';
    ok($handle = ShareFix::I18N->new($lang), "new $lang");
    isa_ok($handle->get_local_handle(), 'Locales');

    is($handle->locale(),$lang,"get locale $lang"); 
}

# languageCode()
{
    my $handle;
    my $lang = 'de_at';
    ok($handle = ShareFix::I18N->new($lang), "new $lang");
    isa_ok($handle->get_local_handle(), 'Locales');

    is($handle->languageCode(),$lang,"get locale $lang");
}

# select_plural_form()

=comment

#### Russian ru  
one 1, 21, 31, 41, 51, 61...       one → n mod 10 is 1 and n mod 100 is not 11;
few 2-4, 22-24, 32-34...           few → n mod 10 in 2..4 and n mod 100 not in 12..14;
many    0, 5-20, 25-30, 35-40...   many → n mod 10 is 0 or n mod 10 in 5..9 or n mod 100 in 11..14;
other   1.2, 2.07, 5.94...        other → everything else



'category_rules' => {
            'few'  => "n\ mod\ 10\ in\ 2\.\.4\ and\ n\ mod\ 100\ not\ in\ 12\.\.14",
            'many' => "n\ mod\ 10\ is\ 0\ or\ n\ mod\ 10\ in\ 5\.\.9\ or\ n\ mod\ 100\ in\ 11\.\.14",
            'one'  => "n\ mod\ 10\ is\ 1\ and\ n\ mod\ 100\ is\ not\ 11"
        },
        'category_rules_compiled' => {
            'few' => sub {
                if (( 
                        ( int( $_[0] ) == $_[0] && ( $_[0] % 10 ) >= 2 && ( $_[0] % 10 ) <= 4 ) 
                            && ( int( $_[0] ) != $_[0] 
                                || ( $_[0] % 100 ) < 12 || ( $_[0] % 100 ) > 14 ) 
                ) ) { return 'few'; }
                return;
            },
            'many' => sub {
                if ( ( 
                    ( ( $_[0] % 10 ) == 0 ) ) 
                    || ( ( int( $_[0] ) == $_[0] && ( $_[0] % 10 ) >= 5 && ( $_[0] % 10 ) <= 9 ) ) 
                    || ( ( int( $_[0] ) == $_[0] && ( $_[0] % 100 ) >= 11 && ( $_[0] % 100 ) <= 14 ) 
                ) ) { return 'many'; }
                return;
            },
            'one' => sub {
                if ( ( ( ( $_[0] % 10 ) == 1 ) && ( ( $_[0] % 100 ) != 11 ) ) ) { return 'one'; }
                return;
              }
              
German de 

German  de  one 1   one → n is 1;
other → everything else other   0, 2-999; 1.2, 2.07...

=cut


my $plural_categories = {
    ru => [
            'one',
            'few',
            'many',
            'other'
        ],
   de => [
            'one',
            'other',
            'zero'
        ],
        
};


my $plural_forms = {
    ru => {
        one => [ 1, 21, 31, 41, 51, 61 ],      
        few => [2,3,4, 22,23,24, 32,33,34 ],    
        many =>  [0, 5..20, 25..30, 35..40 ],   
        other =>  [ 1.2, 2.07, 5.94,  ],        
    } ,
    de => {
        one => [ 1 ],         
        other =>  [ 2..4, 998, 999, 1.2, 2.07  ],
        zero => [0, 0.0, -0.0 ],        
    }  
};

for my $lang ( keys %{$plural_forms} ) {
    my $handle;
    ok($handle = ShareFix::I18N->new($lang), "new $lang");
    isa_ok($handle->get_local_handle(), 'Locales');
    ok($handle->plural_form_categories(),'plural_form_categories');
    
    my @forms = ( @{$plural_categories->{$lang}});
    for my $form (@forms) {
        for my $number ( @{ $plural_forms->{$lang}->{$form} } ) {
            is( $handle->select_plural_form("$number", @forms), $form, "$lang $number $form" );
        }
    }     
}

# format_decimal

my $decimals = {
    en => {
        '1' => '1',
        '1.2' => '1.2',
        '1000' => '1,000',       
    } ,
    de => {
        '1' => '1',
        '1.2' => '1,2',
        '10000' => '10.000',        
    }  
};

for my $lang ( keys %{$decimals} ) {
    my $handle;
    ok($handle = ShareFix::I18N->new($lang), "new $lang");
    isa_ok($handle->get_local_handle(), 'Locales');
    
    for my $number ( keys %{$decimals->{$lang}}) {
        is( $handle->format_decimal("$number"+0), $decimals->{$lang}->{$number}, 
        "$lang $number $decimals->{$lang}->{$number}" );
    }     
}


done_testing();

1;