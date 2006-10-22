use strict;
use Test::Base;
use UNIVERSAL::to_json;

plan tests => 1 * blocks;

filters { input => 'chomp', output => 'chomp' };

run {
    my $block = shift;
    my $input = eval $block->input;
    is $input->to_json, $block->output, $block->name;
}

__END__

=== Object->to_json
--- input
bless { foo => 'bar' }, 'Baz'
--- output
{"foo":"bar"}
