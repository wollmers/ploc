package Unicode::Locale;

sub new {
    my $class = shift;
    my $self = {};
    return bless $self,$class;
}

sub parse {
	my $self = shift;
	my $locale = shift;

=comment



 language      = 2*3ALPHA            ; shortest ISO 639 code
                 ["-" extlang]       ; sometimes followed by
                                     ; extended language subtags
               / 4ALPHA              ; or reserved for future use
               / 5*8ALPHA            ; or registered language subtag

 extlang       = 3ALPHA              ; selected ISO 639 codes
                 *2("-" 3ALPHA)      ; permanently reserved


=cut


    
my $extlang = qr/
    ([a-z]{3}
      (-[a-z]{3}){0,2}
    )
    /xmsi;

my $language = qr/
    (
      ([a-z]{2,3})
      (-$extlang)?
    )
    |([a-z]{4})
    |([a-z]{5,8})
    /xmsi;

#  script        = 4ALPHA              ; ISO 15924 code

my $script = qr/
    ([a-z]{4,4})
    /xmsi;

# region        = 2ALPHA              ; ISO 3166-1 code
#               / 3DIGIT              ; UN M.49 code
 
my $region = qr/
    ([a-z]{2}
    |[0-9]{3})
/x;

# variant       = 5*8alphanum         ; registered variants
#               / (DIGIT 3alphanum)

my $variant = qr/
                [0-9a-z]{5,8}
                |[0-9][0-9a-z]{3,3}
                /xmsi;

# singleton     = DIGIT               ; 0 - 9
#               / %x41-57             ; A - W
#               / %x59-5A             ; Y - Z
#               / %x61-77             ; a - w
#               / %x79-7A             ; y - z

my $singleton = qr/[0-9a-wy-z]/xi;

# extension     = singleton 1*("-" (2*8alphanum))
#
#                                     ; Single alphanumerics
#                                     ; "x" reserved for private use

my $extension = qr/
                $singleton
                (-[a-z0-9]{2,8})+
                /xi;


# privateuse    = "x" 1*("-" (1*8alphanum))

my $privateuse = qr/
                (x
                (-[a-z0-9]{1,8})+
                )/xi;

# grandfathered = irregular           ; non-redundant tags registered
#               / regular             ; during the RFC 3066 era

my $grandfathered = qr/
                ($irregular
                |$regular
                )/x;

# irregular     = "en-GB-oed"         ; irregular tags do not match
#               / "i-ami"             ; the 'langtag' production and
#               / "i-bnn"             ; would not otherwise be
#               / "i-default"         ; considered 'well-formed'
#               / "i-enochian"        ; These tags are all valid,
#               / "i-hak"             ; but most are deprecated
#               / "i-klingon"         ; in favor of more modern
#               / "i-lux"             ; subtags or subtag
#               / "i-mingo"           ; combination
#               / "i-navajo"
#               / "i-pwn"
#               / "i-tao"
#               / "i-tay"
#               / "i-tsu"
#               / "sgn-BE-FR"
#               / "sgn-BE-NL"
#               / "sgn-CH-DE"


my $irregular = qr/
        (en-GB-oed
        |i-ami
        |i-bnn
        |i-default
        |i-enochian
        |i-hak
        |i-klingon
        |i--lux
        |i-mingo
        |i-navajo
        |i-pwn
        i-tao
        |i-tay
        |i-tsu
        |sgn-BE-FR
        |sgn-BE-NL
        |sgn-CH-DE
        )/x;

# regular       = "art-lojban"        ; these tags match the 'langtag'
#               / "cel-gaulish"       ; production, but their subtags
#               / "no-bok"            ; are not extended language
#               / "no-nyn"            ; or variant subtags: their meaning
#               / "zh-guoyu"          ; is defined by their registration
#               / "zh-hakka"          ; and all of these are deprecated
#               / "zh-min"            ; in favor of a more modern
#               / "zh-min-nan"        ; subtag or sequence of subtags
#               / "zh-xiang"

my $regular       = qr/(
                art-lojban   # these tags match the 'langtag'
               |cel-gaulish"       # production, but their subtags
               |no-bok"            # are not extended language
               |no-nyn"            # or variant subtags: their meaning
               |zh-guoyu"          # is defined by their registration
               |zh-hakka"          # and all of these are deprecated
               |zh-min"            # in favor of a more modern
               |zh-min-nan"        # subtag or sequence of subtags
               |zh-xiang"
               )/x;

=comment

my $tag = qr/
    $language
    (-$script)?
    (-$region)?
    (-$variant)?
    /xi;
    
=cut
    
my $tag = qr/^
    $language
    (-$script)?
    (-$region)?
    (-$variant)?
    $/xmsi;
    
    return $locale =~ m/$tag/xi;
    
    return %args;
}

1;
