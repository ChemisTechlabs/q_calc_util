import 'package:q_calc_util/src/dixon_exception.dart';
import 'package:q_calc_util/src/dixon_result.dart';

/// A class for calculating Dixon's Q test for outlier detection.
class DixonCalculator {
  static final DixonCalculator _instance = DixonCalculator._();

  DixonCalculator._();

  /// Returns the singleton instance of the [DixonCalculator].
  static DixonCalculator get instance => _instance;

  /// The limit values for 95% of confidence, based on the sample size (n).
  /// Used to compare against the calculated Q value.
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
    30: 0.412,
  };

  /// The limit values for 99% of confidence, based on the sample size (n).
  /// Used to compare against the calculated Q value.
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
    30: 0.483,
  };

  /// Calculates the Dixon Q test and returns a [DixonResult].
  ///
  /// The [values] parameter is a set of numerical values to be tested.
  /// The [confidence] parameter specifies the confidence level (95% or 99%).
  ///
  /// This method iteratively removes outliers from the dataset based on the
  /// Dixon Q test until no more outliers are detected.
  ///
  /// Throws a [DixonException] if the number of values is less than 3 or greater than 30.
  DixonResult calculate({
    required Set<double> values,
    required Confidence confidence,
  }) {
    // Prepares values before calculation

    switch (values.length) {
      case < 3:
        throw DixonException('n is lower than 3');
      case > 30:
        throw DixonException('n is greater than 30');
    }

    final sortedValues = values.toList()..sort();
    var lowerEnd = 0.0;
    var upperEnd = 0.0;
    List<double> removedValues = [];

    while (true) {
      switch (sortedValues.length) {
        case < 3:
          throw DixonException('n is lower than 3');
        case <= 7:
          lowerEnd = _getLowerEnd3_7(sortedValues);
          upperEnd = _getUpperEnd3_7(sortedValues);
        case <= 12:
          lowerEnd = _getLowerEnd8_12(sortedValues);
          upperEnd = _getUpperEnd8_12(sortedValues);
        case >= 13:
          lowerEnd = _getLowerEnd13(sortedValues);
          upperEnd = _getUpperEnd13(sortedValues);
      }

      if (!_isApproved(lowerEnd, confidence, sortedValues.length)) {
        removedValues.add(sortedValues.removeAt(0)); //removed the first value
        continue;
      }

      if (!_isApproved(upperEnd, confidence, sortedValues.length)) {
        removedValues.add(sortedValues.removeLast()); //removed last values
        continue;
      }

      return DixonResult(
        values: sortedValues,
        confidence: confidence,
        lowerEnd: lowerEnd,
        upperEnd: upperEnd,
        removedValues: removedValues,
        q: _getQ(confidence, sortedValues.length),
      );
    }
  }

  /// Returns a double value from Dixon constants map representing the Q value for
  /// the given `confidence` and `n` value
  double _getQ(Confidence confidence, int n) => switch (confidence) {
    Confidence.percent95 => _qTable95[n]!,
    Confidence.percent99 => _qTable99[n]!,
  };

  /// Checks if the calculated Q value is approved (less than) the critical Q value
  /// from the table for the given confidence level and sample size (n).
  bool _isApproved(double value, Confidence confidence, int n) {
    return value < _getQ(confidence, n);
  }

  /// Calculates the Q value for the lower end of the dataset when n is between 3 and 7.
  double _getLowerEnd3_7(List<double> values) {
    return (values[1] - values.first) / (values.last - values.first);
  }

  /// Calculates the Q value for the lower end of the dataset when n is between 8 and 12.
  double _getLowerEnd8_12(List<double> values) {
    return (values[1] - values.first) /
        (values[values.length - 2] - values.first);
  }

  /// Calculates the Q value for the lower end of the dataset when n is greater than or equal to 13.
  double _getLowerEnd13(List<double> values) {
    return (values[2] - values.first) /
        (values[values.length - 3] - values.first);
  }

  /// Calculates the Q value for the upper end of the dataset when n is between 3 and 7.
  double _getUpperEnd3_7(List<double> values) {
    return (values.last - values[values.length - 2]) /
        (values.last - values.first);
  }

  /// Calculates the Q value for the upper end of the dataset when n is between 8 and 12.
  double _getUpperEnd8_12(List<double> values) {
    return (values.last - values[values.length - 2]) /
        (values.last - values[1]);
  }

  /// Calculates the Q value for the upper end of the dataset when n is greater than or equal to 13.
  double _getUpperEnd13(List<double> values) {
    return (values.last - values[values.length - 3]) /
        (values.last - values[2]);
  }
}
