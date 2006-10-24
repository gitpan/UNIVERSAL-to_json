use inc::Module::Install;
name 'UNIVERSAL-to_json';
all_from 'lib/UNIVERSAL/to_json.pm';
license 'MIT';
build_requires 'Test::More';
requires 'Best';
if (can_cc()) {
    requires 'JSON::Syck';
}
else {
    requires 'JSON' unless can_use 'JSON::Syck';
}
use_test_base;
auto_include;
WriteAll;
