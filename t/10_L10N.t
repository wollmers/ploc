use strict;
use warnings;

use utf8;
use lib "../lib";

use open        qw< :std  :utf8     >;

use Test::More;   # see done_testing()

my $module = 'ShareFix::L10N';

BEGIN { 
    use_ok( 'ShareFix::L10N' );
    use_ok('ShareFix::I18N'); 
}

can_ok($module, qw < 
get_language_handle
get_local_handle
get_available_languages
get_default_language
quant
numf
locdate
>);



my @locales = qw < de de_DE de_de de-DE de-Latn-spelling1996 de-de de_AT en en_US fr ru xy >;

for my $locale ( @locales ) {
    my $handle;
    ok($handle = ShareFix::L10N->get_language_handle($locale), "ShareFix::L10N->get_language_handle $locale");
    isa_ok($handle,'ShareFix::L10N');
    isa_ok($handle->get_local_handle(), 'ShareFix::I18N');     
}

my $maketexts = {
    de => {
        'no' => 'nein',
        'This is a text.' => 'Dies ist ein Text.',
        'This is text with utf €.' => 'Das ist Text mit utf €.',
    },
    en => {
        'no' => 'no',
        'This is a text.' => 'This is a text.',
        'This is text with utf €.' => 'This is text with utf €.',
    },      
};

for my $locale (sort keys %{$maketexts} ) {
    my $handle;
    ok($handle = ShareFix::L10N->get_language_handle($locale), "ShareFix::L10N->get_language_handle $locale");
    isa_ok($handle,'ShareFix::L10N');
    isa_ok($handle->get_local_handle(), 'ShareFix::I18N');
    #%ShareFix::L10N::de = %{$maketexts->{$locale}};
    for my $phrase (sort keys %{$maketexts->{$locale}}) {
        is($handle->maketext($phrase),$maketexts->{$locale}->{$phrase}, "maketext $phrase ");
    }     
}

my $quantifiers = {
    de => {
        'This returns [quant,_1,result,results] back.' => [
            [0,'Das gibt 0 Ergebnisse zurück.'],
            [1,'Das gibt 1 Ergebnis zurück.'],
            [2,'Das gibt 2 Ergebnisse zurück.'],
            [1000,'Das gibt 1,000 Ergebnisse zurück.'],
            ],
        'This returns [quant,_1,result,results,results] back.' => [
            [0,'Das gibt 0 Ergäbnisse zurück.'],
            [1,'Das gibt 1 Ergebnis zurück.'],
            [2,'Das gibt 2 Ergebnisse zurück.'],
            ],
    },
    en => {
        'This returns [quant,_1,result,results] back.' => [
            [0,'This returns 0 results back.'],
            [1,'This returns 1 result back.'],
            [2,'This returns 2 results back.'],
            [1000,'This returns 1,000 results back.'],
            ],
        'This returns [quant,_1,result,results,results] back.' => [
            [0,'This returns 0 results back.'],
            [1,'This returns 1 result back.'],
            [2,'This returns 2 results back.'],
            ],
    },      
};

for my $locale (sort keys %{$quantifiers} ) {
    my $handle;
    ok($handle = ShareFix::L10N->get_language_handle($locale), "ShareFix::L10N->get_language_handle $locale");
    for my $phrase (sort keys %{$quantifiers->{$locale}}) {
        for my $test_case (@{$quantifiers->{$locale}->{$phrase}}) {
            my ($number,$result) = @{$test_case};
            is($handle->maketext($phrase,$number),$result, "maketext $phrase $number $result");
        }
    }     
}

done_testing();

1;