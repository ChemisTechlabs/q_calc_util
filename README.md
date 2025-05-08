# Q Calc Util

<!-- badges -->

![Build Status](https://github.com/ChemisTechlabs/q_calc_util/workflows/Dart%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/ChemisTechlabs/q_calc_util/badge.svg?branch=master)](https://coveralls.io/github/ChemisTechlabs/q_calc_util?branch=master)

Q Calc Util is a Dixon's Q Test library for Dart developers. It makes
easier for developers to perform outliers check in a range between 3 and 30 values

## Usage

Add the following import to your Dart code:

```dart
import 'package:q_calc_util/q_calc_util.dart';

void printResults(DixonResult result) {
  print('''
      Confidence: ${result.confidence.toString()}
       Lower end: ${result.lowerEnd.toStringAsFixed(3)}
       Upper end: ${result.upperEnd.toStringAsFixed(3)}
               Q: ${result.q.toStringAsFixed(3)}
               N: ${result.n}
          Values: ${result.values.toString()}
  Removed values: ${result.removedValues.toString()}
  ''');
}

void main() {
  var values = {0.764, 0.864, 0.936, 0.047, 1.028, 1.043};

  try {
    final result95 = DixonCalculator.instance.calculate(
      values: values,
      confidence: Confidence.percent95,
    );
    printResults(result95);
  } on DixonException catch (error) {
    print(error.message);
  }

  try {
    final result99 = DixonCalculator.instance.calculate(
      values: values,
      confidence: Confidence.percent99,
    );
    printResults(result99);
  } on DixonException catch (error) {
    print(error.message);
  }
}

//     Confidence: 95%
//      Lower end: 0.358
//      Upper end: 0.054
//              Q: 0.710
//              N: 5
//         Values: [0.764, 0.864, 0.936, 1.028, 1.043]
// Removed values: [0.047]

//     Confidence: 99%
//      Lower end: 0.720
//      Upper end: 0.015
//              Q: 0.740
//              N: 6
//         Values: [0.047, 0.764, 0.864, 0.936, 1.028, 1.043]
// Removed values: []
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ChemisTechlabs/q_calc_util/issues
