use strict;
use Test::More tests => 1;
use UNIVERSAL::to_json;

like UNIVERSAL::to_json::which(), qr{ JSON(::Syck)? }x, 'UNIVERSAL::to_json::which';
