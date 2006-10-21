package UNIVERSAL::to_json;

use strict;
use warnings;
use Best [qw(JSON::Syck JSON)];

our $VERSION = '0.01';
our $loaded; # reserves the module name loaded actually

sub import {
    $loaded = Best->which('JSON::Syck');

    if ($loaded eq 'JSON::Syck') {
        *UNIVERSAL::to_json = sub {
            return JSON::Syck::Dump($_[0]);
        };
    }
    elsif ($loaded eq 'JSON') {
        *UNIVERSAL::to_json = sub {
            my $self = shift;

            # XXX
            # Because JSON module ridigly observes JSON specification
            # that specifies that JSON is built on two structures,
            # hash and ordered list, JSON::objToJson method ignores
            # both string and a reference to string passed in. So I
            # hack here to make consistent between JSON and JSON::Syck
            # implementation.

            if (ref $self eq 'SCALAR') {
                my $json =  JSON::objToJson([$$self]);
                   $json =~ s/\[([^]]+)\]/$1/;

                return $json;
            }
            else {
                local $JSON::ConvBlessed = 1;
                return JSON::objToJson($self);
            }
        };
    }
}

sub which {
    return $loaded;
}

package SCALAR;

sub to_json {
    if (UNIVERSAL::to_json::which eq 'JSON') {
        UNIVERSAL::to_json(\$_[0]);
    }
    else {
        UNIVERSAL::to_json($_[0]);
    }
}

package ARRAY;

sub to_json { UNIVERSAL::to_json($_[0]) }

package HASH;

sub to_json { UNIVERSAL::to_json($_[0]) }

1;

__END__

=head1 NAME

UNIVERSAL::to_json - to_json() method for all objects.

=head1 VERSION

This document describes UNIVERSAL::to_json version 0.01

=head1 SYNOPSIS

  use UNIVERSAL::to_json;

  my $obj = Foo->new;
  print $obj->to_json;

  {
      use autobox; # activate autobox

      print 'scalar value'->to_json;   #=> "scalar value"
      print [qw(list items)]->to_json; #=> ["list","items"]
      print {key => 'value'}->to_json; #=> {"key":"value"}

      no autobox;  # inactivate autobox

      print {key => 'value'}->to_json;
      #=> 'Can't call method "to_json" on unblessed reference'
  }

=head1 DESCRIPTION

UNIVERSAL::to_json provides to_json() method to all objects.

Besides, it supports you to extend unblessed values like a scalar, a
reference to an array and a reference to a hash to be able to be
called to_json() method from them directly. This feature is optional,
and owes to brilliant L<autobox>.

B<NOTE>: This distribution doesn't designate L<autobox> module as
pre-required. If you want the feature to be able to add to_json()
method into unblessed values, you need to install it by your hand in
advance.

=head1 METHODS

=head2 to_json()

=over 4

  my $obj = Foo->new;
  print $obj->to_json;

  use autobox;

  print 'scalar value'->to_json;
  print [qw(list items)]->to_json;
  print {key => 'value'}->to_json;

  no autobox;

to_json() method dumps the current object as JSON.

If L<autobox> is activated, to_json() method can be called magically
from unblessed values.

=back

=head2 which()

=over 4

  my $loaded = UNIVERSAL::to_json::which();

This method returns which of JSON or JSON::Syck is loaded actually.

So you can recognize which module is loaded and assign some values to
the package variables privided by the loaded module to set options and
control outputs from to_json() method.

  my $loaded = UNIVERSAL::to_json::which;

  if ($loaded eq 'JSON') {
      $JSON::UTF8 = 1;
  }
  else {
      $JSON::Syck::ImplicitUnicode = 1;
  }

For more details on the options, see the documentations of both
L<JSON> and L<JSON::Syck>.

=back

=head1 DEPENDENCIES

You must have JSON or JSON::Syck installed. UNIVERSAL::to_json prefers
later over former if you have them both.

=head1 SEE ALSO

=over 4

=item * L<UNIVERSAL::to_yaml>

UNIVERSAL::to_json wholly borrows the idea from L<UNIVERSAL::to_yaml>.

=item * L<autobox>

For more details on L<autobox>, consult the documentation of it.

=item * L<JSON>, L<JSON::Syck>

The documentations linked above will help you to know the options that
enable you to control outputs from to_json() method.

=back

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentaro@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE (The MIT License)

Copyright (c) 2006, Kentaro Kuribayashi E<lt>kentaro@cpan.orgE<gt>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut
