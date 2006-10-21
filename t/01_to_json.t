use strict;
use Test::Base;
use UNIVERSAL::to_json;

plan 'no_plan';

filters { input => 'chomp', output => 'chomp' };

eval q{ use autobox; };
if ($@) {
    my $block = first_block();
    my $input = eval $block->input;
    is $input->to_json, $block->output, $block->name;
}
else {
    run {
        use autobox;
        my $block = shift;
        my $input = eval $block->input;
        is $input->to_json, $block->output, $block->name;
    }
}

__END__

=== Object->to_json
--- input
bless { foo => 'bar' }, 'Baz'
--- output
{"foo":"bar"}

=== Scalar->to_json
--- input
'scalar value'
--- output
"scalar value"

=== ArrayRef->to_json
--- input
[qw(list items)]
--- output
["list","items"]

=== HashRef->to_json
--- input
{ key => 'value' }
--- output
{"key":"value"}
