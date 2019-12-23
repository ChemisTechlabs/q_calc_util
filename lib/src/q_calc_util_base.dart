/*
MIT License

Copyright (c) 2018 Chemis Techlabs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
*/

/// The available percentage of confidence to calculate Dixon's Q Test
enum Confidence { percent95, percent99 }

// The limit values for 95% of confidence
final Map<int, double> _qTable95 = {
  3: 0.970,
  4: 0.829,
  5: 0.710,
  6: 0.628,
  7: 0.569,
  8: 0.608,
  9: 0.564,
  10: 0.530,
  11: 0.502,
  12: 0.479,
  13: 0.611,
  14: 0.586,
  15: 0.565,
  16: 0.546,
  17: 0.529,
  18: 0.514,
  19: 0.501,
  20: 0.489,
  21: 0.478,
  22: 0.468,
  23: 0.459,
  24: 0.451,
  25: 0.443,
  26: 0.436,
  27: 0.429,
  28: 0.423,
  29: 0.417,
  30: 0.412
};

// The limit values for 99% of confidence
final Map<int, double> _qTable99 = {
  3: 0.994,
  4: 0.926,
  5: 0.821,
  6: 0.740,
  7: 0.608,
  8: 0.717,
  9: 0.672,
  10: 0.635,
  11: 0.605,
  12: 0.579,
  13: 0.697,
  14: 0.670,
  15: 0.647,
  16: 0.627,
  17: 0.610,
  18: 0.594,
  19: 0.580,
  20: 0.567,
  21: 0.555,
  22: 0.544,
  23: 0.535,
  24: 0.526,
  25: 0.517,
  26: 0.510,
  27: 0.502,
  28: 0.495,
  29: 0.489,
  30: 0.483
};

/// Returns a double value from Dixon constants map representing the Q value for
/// the given `confidence` and `n` value
double _getQ(Confidence confidence, int n) {
  switch (confidence) {
    case Confidence.percent95:
      return _qTable95[n];
    case Confidence.percent99:
      return _qTable99[n];
    default:
      return -1.0;
  }
}

//Checks if value is approved under given confidence and n
bool _isApproved(double value, Confidence confidence, int n) {
  return (value < _getQ(confidence, n));
}

//lower end functions
double _getLowerEnd3_7(List<double> values) {
  return (values[1] - values.first) / (values.last - values.first);
}

double _getLowerEnd8_12(List<double> values) {
  return (values[1] - values.first) /
      (values[values.length - 2] - values.first);
}

double _getLowerEnd13(List<double> values) {
  return (values[2] - values.first) /
      (values[values.length - 3] - values.first);
}

//Upper end functions
double _getUpperEnd3_7(List<double> values) {
  return (values.last - values[values.length - 2]) /
      (values.last - values.first);
}

double _getUpperEnd8_12(List<double> values) {
  return (values.last - values[values.length - 2]) / (values.last - values[1]);
}

double _getUpperEnd13(List<double> values) {
  return (values.last - values[values.length - 3]) / (values.last - values[2]);
}

DixonResults _calculateQTest(List<double> values, DixonResults results) {
  var lowerEnd = 0.0;
  var upperEnd = 0.0;

  if (values.length < 3) {
    throw DixonException('n is lower than 3');
  } else if (values.length <= 7) {
    lowerEnd = _getLowerEnd3_7(values);
    upperEnd = _getUpperEnd3_7(values);
  } else if (values.length <= 12) {
    lowerEnd = _getLowerEnd8_12(values);
    upperEnd = _getUpperEnd8_12(values);
  } else if (values.length >= 13) {
    lowerEnd = _getLowerEnd13(values);
    upperEnd = _getUpperEnd13(values);
  }

  if (_isApproved(lowerEnd, results.confidence, values.length)) {
    results.lowerEnd = lowerEnd;
  } else {
    results.removedValues.add(values.removeAt(0)); //removed the first value
    results.lowerEnd = _calculateQTest(values, results).lowerEnd;
  }

  if (_isApproved(upperEnd, results.confidence, values.length)) {
    results.upperEnd = upperEnd;
  } else {
    results.removedValues.add(values.removeLast()); //removed last values
    results.upperEnd = _calculateQTest(values, results).upperEnd;
  }

  return results;
}

/// A representation of a Q Test calculation result
class DixonResults {
  double lowerEnd;
  double upperEnd;
  List<double> values;
  List<double> removedValues = [];
  final Confidence _confidence;

  DixonResults(this._confidence, this.values);

  /// The enum representing the confidence used in calculation
  Confidence get confidence => _confidence;

  /// The length of [values] attribute
  int get n => values.length;

  /// The Q constant from Dixon's table for the resulting n and given confidence
  double get q => _getQ(confidence, n);
}

/// A representation of a Q Test error
class DixonException implements Exception {
  /// Message describing the Dixon error
  final String message;

  /// Creates a new [DixonException] with optional message
  DixonException([this.message = '']);

  @override
  String toString() => 'DixonException: $message';
}

/// Returns a [DixonResults] object representing the result of Q test calculation
///
/// Throws a [DixonException] if 'n' is or got lower than 3 during
/// the calculation
DixonResults calculateQTest(List<double> values, Confidence confidence) {
  // Prepares values before calculation
  var filteredValues = values.toSet().toList();
  filteredValues.sort();

  filteredValues.length < 3 && (throw DixonException('n is lower than 3'));
  filteredValues.length > 30 && (throw DixonException('n is greater than 30'));
  return _calculateQTest(
      filteredValues, DixonResults(confidence, filteredValues));
}
