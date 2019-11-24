# Q Calc Util

<!-- badges -->

[![Build Status](https://github.com/ChemisTechlabs/q_calc_util/workflows/Dart%20CI/badge.svg)]()
[![Coverage Status](https://coveralls.io/repos/github/ChemisTechlabs/q_calc_util/badge.svg?branch=master)](https://coveralls.io/github/ChemisTechlabs/q_calc_util?branch=master)

Q Calc Util is a Dixon's Q Test library for Dart developers. It makes
easier for developers to perform outliers check in a range between 3 and 30 values

## Usage

Add the following import to your Dart code:

```dart
import 'package:q_calc_util/q_calc_util.dart';
```

Then you can get a `DixonResults` object containing Q Test results just calling
`calculateQTest` function like this:

```dart
// List of values to check outliers
List<double> values = [0.764, 0.864, 0.936, 0.047, 1.028, 1.043];

try {
  // Calculates Q Test using 95% of confidence
  DixonResults result = calculateQTest(values, Confidence.percent95);

  print("""
        Confidence: 95%
         Lower end: ${result.lowerEnd.toStringAsFixed(3)}
         Upper end: ${result.upperEnd.toStringAsFixed(3)}
                 Q: ${result.q}
                 N: ${result.n}
            Values: ${result.values.toString()}
    Removed values: ${result.removedValues.toString()}
    """);
} on DixonException catch (error) {
  // Catches DixonException in case of 'n' lower than 3 values
  print(error.toString());
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ChemisTechlabs/q_calc_util/issues
