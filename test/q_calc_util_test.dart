import 'package:q_calc_util/q_calc_util.dart';
import 'package:test/test.dart';

void main() {
  List<double> values1 = [0.988, 0.978, 0.8, 0.987, 0.4, 1.9, 0.49, 0.87];
  List<double> values2 = [
    0.678,
    0.875,
    0.536,
    0.191,
    0.003,
    0.108,
    0.972,
    0.829,
    0.890,
    0.176,
    0.307,
    0.913,
    0.028,
    0.137,
    0.479,
    0.280,
    0.573,
    0.646,
    0.660,
    0.722,
    0.021,
    0.759,
    0.590,
    0.194,
    0.176,
    0.497,
    0.759,
    0.447,
    0.408,
    0.038,
    0.466,
    0.656,
    0.928,
    0.523,
    0.366,
    0.240,
    0.329,
    0.265,
    0.835,
    0.501
  ];
  List<double> values3 = [
    0.362,
    0.743,
    0.516,
    0.437,
    0.683,
    0.347,
    0.072,
    0.400,
    0.022,
    0.954,
    0.515,
    0.531,
    0.616,
    0.375,
    0.354,
    0.118,
    0.125,
    0.837,
    0.783,
    0.087
  ];
  List<double> values4 = [0.2, 0.4, 0.2];
  List<double> values5 = [
    15.00,
    19.50,
    20.00,
    21.70,
    22.00,
    30.00,
    32.50,
    35.70,
    36.00,
    36.20,
    39.00,
    57.00,
    89.00,
    90.00
  ];
  group('95% confidence tests', () {
    test('Pass tests with list values1', () {
      DixonResults results = calculateQTest(values1, Confidence.percent95);

      expect(results.q, equals(0.569));
      expect(results.n, equals(7));
      expect(results.lowerEnd.toStringAsFixed(4), equals("0.1531"));
      expect(results.upperEnd.toStringAsFixed(4), equals("0.0017"));
      expect(results.removedValues.length, equals(1));
      expect(results.removedValues, equals([1.9]));
    });

    test('Pass tests with list values2', () {
      try {
        calculateQTest(values2, Confidence.percent95);
      } catch (error) {
        expect(error is DixonException, true);
        expect(error.message, "n is greater than 30");
      }
    });

    test('Pass tests with list values3', () {
      DixonResults results = calculateQTest(values3, Confidence.percent95);

      expect(results.q, equals(0.489));
      expect(results.n, equals(20));
      expect(results.lowerEnd.toStringAsFixed(4), equals("0.0854"));
      expect(results.upperEnd.toStringAsFixed(4), equals("0.1972"));
      expect(results.removedValues.length, equals(0));
      expect(results.removedValues, equals([]));
    });

    test('Pass tests with list values4', () {
      try {
        calculateQTest(values4, Confidence.percent95);
      } catch (error) {
        expect(error is DixonException, true);
        expect(error.message, "n is lower than 3");
      }
    });

    test('Pass tests with list values5', () {
      DixonResults results = calculateQTest(values5, Confidence.percent95);

      expect(results.q, equals(0.586));
      expect(results.n, equals(14));
      expect(results.lowerEnd.toStringAsFixed(4), equals("0.1190"));
      expect(results.upperEnd.toStringAsFixed(4), equals("0.4714"));
      expect(results.removedValues.length, equals(0));
      expect(results.removedValues, equals([]));
    });
  });

  group('99% confidence tests', () {
    test('Pass tests with list values1', () {
      DixonResults results = calculateQTest(values1, Confidence.percent99);

      expect(results.q, equals(0.717));
      expect(results.n, equals(8));
      expect(results.lowerEnd.toStringAsFixed(4), equals("0.1531"));
      expect(results.upperEnd.toStringAsFixed(4), equals("0.6468"));
      expect(results.removedValues.length, equals(0));
      expect(results.removedValues, equals([]));
    });

    test('Pass tests with list values2', () {
      try {
        calculateQTest(values2, Confidence.percent99);
      } catch (error) {
        expect(error is DixonException, true);
        expect(error.message, "n is greater than 30");
      }
    });

    test('Pass tests with list values3', () {
      DixonResults results = calculateQTest(values3, Confidence.percent99);

      expect(results.q, equals(0.567));
      expect(results.n, equals(20));
      expect(results.lowerEnd.toStringAsFixed(4), equals("0.0854"));
      expect(results.upperEnd.toStringAsFixed(4), equals("0.1972"));
      expect(results.removedValues.length, equals(0));
      expect(results.removedValues, equals([]));
    });

    test('Pass tests with list values4', () {
      try {
        calculateQTest(values4, Confidence.percent99);
      } catch (error) {
        expect(error is DixonException, true);
        expect(error.message, "n is lower than 3");
      }
    });

    test('Pass tests with list values5', () {
      DixonResults results = calculateQTest(values5, Confidence.percent99);

      expect(results.q, equals(0.670));
      expect(results.n, equals(14));
      expect(results.lowerEnd.toStringAsFixed(4), equals("0.1190"));
      expect(results.upperEnd.toStringAsFixed(4), equals("0.4714"));
      expect(results.removedValues.length, equals(0));
      expect(results.removedValues, equals([]));
    });
  });
}
