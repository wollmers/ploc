package PLoc;

use strict;
use warnings;

sub new {}

sub get_cldr_version {
}

# locale
sub get_locale {}

sub get_locale_origin {}

sub get_locale_normalized {}

sub get_locale_effective {}

sub parse_locale {}

# customizing

sub register_locale {}

# languages
sub language_from_code {}

sub code_from_language {}

sub language_native {}

sub language_codes {}

sub language_names {}

sub languages {}

sub code2language {
    shift->language_from_code(@_);
}
sub language2code {
    shift->code_from_language(@_);
}
sub all_language_codes {
    shift->language_codes();
}
sub all_language_names {
    shift->language_names();
}


# territories
sub territory_from_code {}

sub code_from_territory {}

sub territory_codes {}

sub territory_names {}

sub territories {}
sub code2country {}
sub country2code {}
sub all_country_codes {}
sub all_country_names {}

# decimals

sub decimal {}

sub number_group {}

sub format_number {}

# DateTime

# plural forms

sub get_plural_categories {}

sub select_plural_form {}
