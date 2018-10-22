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

enum Confidence { percent95, percent99 }

//Limit values for 95% of confidence
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

//Limit values for 99% of confidence
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
  return (values[1] - values[0]) / (values[values.length - 1] - values[0]);
}

double _getLowerEnd8_12(List<double> values) {
  return (values[1] - values[0]) / (values[values.length - 2] - values[0]);
}

double _getLowerEnd13(List<double> values) {
  return (values[2] - values[0]) / (values[values.length - 3] - values[0]);
}

//Upper end functions
double _getUpperEnd3_7(List<double> values) {
  return (values[values.length - 1] - values[values.length - 2]) /
      (values[values.length - 1] - values[0]);
}

double _getUpperEnd8_12(List<double> values) {
  return (values[values.length - 1] - values[values.length - 2]) /
      (values[values.length - 1] - values[1]);
}

double _getUpperEnd13(List<double> values) {
  return (values[values.length - 1] - values[values.length - 3]) /
      (values[values.length - 1] - values[2]);
}

DixonResults _recursiveCalc(List<double> values, DixonResults resultsObj) {
  double lowerEnd = 0.0;
  double upperEnd = 0.0;

  if (values.length < 3) {
    throw "'n' is lower than 3";
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

  if (_isApproved(lowerEnd, resultsObj.confidence, values.length)) {
    resultsObj.lowerEnd = lowerEnd;
  } else {
    resultsObj.removedValues.add(values.removeAt(0)); //removed the first value
    resultsObj.lowerEnd = _recursiveCalc(values, resultsObj).lowerEnd;
  }

  if (_isApproved(upperEnd, resultsObj.confidence, values.length)) {
    resultsObj.upperEnd = upperEnd;
  } else {
    resultsObj.removedValues.add(values.removeLast()); //removed last values
    resultsObj.upperEnd = _recursiveCalc(values, resultsObj).upperEnd;
  }

  return resultsObj;
}

DixonResults calc(List<double> values, Confidence confidence) {
  List<double> filteredValues = values.toSet().toList();
  filteredValues.sort();

  return _recursiveCalc(
      filteredValues, DixonResults(confidence, filteredValues));
}

class DixonResults {
  double lowerEnd;
  double upperEnd;
  List<double> values;
  List<double> removedValues=[];
  final Confidence _confidence;

  DixonResults(this._confidence, this.values);

  get confidence => _confidence;

  get n => values.length;

  get q => _getQ(confidence, n);
}

// TODO: add docs