default:
    @just --list

publish:
    dart pub publish

publish-dry-run:
    dart pub publish --dry-run

run-example:
    dart run example/q_calc_util_example.dart

analyze:
    dart analyze

test:
    dart test

format:
    dart format

get-dependencies:
    dart pub get
