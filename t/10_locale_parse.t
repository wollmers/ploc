use strict;
use warnings;

use utf8;
use Test::More;

use lib "../lib";

use open        qw< :std  :utf8     >;

use Test::More;   # see done_testing()


BEGIN { 
    use_ok( 'Unicode::Locale' );
}

my $module = 'Unicode::Locale';

can_ok($module, qw < 
new
parse
>);

my $locale;

ok($locale = Unicode::Locale->new(),'new ok');

# language
ok($locale->parse('DE'),'DE');
ok($locale->parse('de'),'de');
ok($locale->parse('mdy'),'mdy');

ok(!$locale->parse('m1'),'m1');
ok(!$locale->parse('d'),'d');
ok(!$locale->parse(undef),'undef');
ok(!$locale->parse(''),'empty string');

# extended language subtags
ok($locale->parse('DE-FOO'),'DE-FOO');
ok($locale->parse('DE-FOO-BAR'),'DE-FOO-BAR');
ok($locale->parse('DE-FOO-BAR-BAZ'),'DE-FOO-BAR-BAZ');

ok(!$locale->parse('DE-FO9'),'DE-FO9');
ok(!$locale->parse('DE-FO-BAR'),'DE-FO-BAR');
ok(!$locale->parse('DE-FOO-BA-BAZ'),'DE-FOO-BA-BAZ');
ok(!$locale->parse('DE-FOO-BAR-BAZ-BAT'),'DE-FOO-BAR-BAZ-BAT');

# script
ok($locale->parse('de-latn'),'de-latn');

# region
ok($locale->parse('de-de'),'de-de');
ok($locale->parse('de-123'),'de-123');

ok($locale->parse('de-latn-de'),'de-latn-de');
ok($locale->parse('de-latn-123'),'de-latn-123');


ok(!$locale->parse('de-d'),'de-d');
ok(!$locale->parse('de-1'),'de-1');

# variant
# [0-9a-z]{5,8}
ok($locale->parse('de-12345'),'de-12345');
ok($locale->parse('de-12345678'),'de-12345678');
ok($locale->parse('de-abcde'),'de-abcde');

# [0-9][0-9a-z]{3,3}
ok($locale->parse('de-1abc'),'de-1abc');


