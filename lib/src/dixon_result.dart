/// The available percentage of confidence to calculate Dixon's Q Test
enum Confidence {
  /// Represents a 95% confidence level for the Q test.
  percent95,

  /// Represents a 99% confidence level for the Q test.
  percent99;

  @override
  String toString() => switch (this) {
    Confidence.percent95 => '95%',
    Confidence.percent99 => '99%',
  };
}

/// A representation of a Q Test calculation result
class DixonResult {
  /// Creates a new [DixonResult] instance.
  ///
  /// [confidence] The confidence level used for the Q test.
  /// [values] The original list of values used in the Q test.
  /// [removedValues] The list of values that were identified as outliers and removed.
  /// [lowerEnd] The potential outlier at the lower end of the dataset, if identified.
  /// [upperEnd] The potential outlier at the upper end of the dataset, if identified.
  /// [q] The calculated Q value from the Q test.
  DixonResult({
    required Confidence confidence,
    required List<double> values,
    required List<double> removedValues,
    required double lowerEnd,
    required double upperEnd,
    required double q,
  }) : _confidence = confidence,
       _values = values,
       _removedValues = removedValues,
       _lowerEnd = lowerEnd,
       _upperEnd = upperEnd,
       _q = q;

  final Confidence _confidence;
  final List<double> _values;
  final List<double> _removedValues;
  final double _lowerEnd;
  final double _upperEnd;
  final double _q;

  /// The enum representing the confidence used in calculation
  Confidence get confidence => _confidence;

  /// Original values used in the calculation
  List<double> get values => _values;

  /// Values identified as outliers and removed from the dataset.
  List<double> get removedValues => _removedValues;

  /// The potential outlier at the lower end of the dataset.
  double get lowerEnd => _lowerEnd;

  /// The potential outlier at the upper end of the dataset.
  double get upperEnd => _upperEnd;

  /// The Q constant from Dixon's table for the resulting n and given confidence
  double get q => _q;

  /// The length of [values] attribute
  int get n => _values.length;

  /// Converts the [DixonResult] object to a JSON representation.
  Map<String, dynamic> toJson() => {
    'confidence': _confidence.name,
    'values': _values,
    'removedValues': _removedValues,
    'lowerEnd': _lowerEnd,
    'upperEnd': _upperEnd,
    'q': _q,
    'n': n,
  };
}
