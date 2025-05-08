# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-04-07

### Added

- Named parameters
- More comprehensive API

### Changed

- Refactored project, splitting dependencies and responsibilities.
- Uses DixonCalculator to call the Q Calc test using a single instance.
- Results are now immutable classes.
- Updated dependencies.
- Updated logic using new Dart SDK 3.7.0.
- Migrated license to BSD-3.

### Removed

- Recursive function used to calculate upper and lower ends.

## [1.1.0] - 2024-02-20

### Added

- Makefile with commands to publish to pub.dev

### Changed

- Update dependencies
- Update environment constraints

## [1.0.0] - 2021-09-12

### Added

- Support to sound null safety

### Changed

- Update deprecated dependencies

## [0.1.2] - 2019-12-23

### Changed

- Update code to match Pedantic recommendations

### Fixed

- Code examples

## [0.1.1+1] - 2019-11-24

### Changed

- Update dependencies
- Update CI/CD and coverage API

## [0.1.1] - 2018-11-04

### Fixed

- Error when n is out of bounds. Throws DixonException when not 3 < n =< 30

## [0.1.0] - 2018-10-21

- Initial release
