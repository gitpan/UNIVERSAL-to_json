use inc::Module::Install;
name 'UNIVERSAL-to_json';
all_from 'lib/UNIVERSAL/to_json.pm';
license 'MIT';
requires 'Best';
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
