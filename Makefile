all: dry-run

publish:
	dart pub publish

analyze:
	dart analyze

dry-run:
	dart pub publish --dry-run