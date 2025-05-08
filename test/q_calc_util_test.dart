import 'package:q_calc_util/q_calc_util.dart';
import 'package:test/test.dart';

void main() {
  final values1 = [0.988, 0.978, 0.8, 0.987, 0.4, 1.9, 0.49, 0.87];
  final values2 = [
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
    0.501,
  ];
  final values3 = [
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
    0.087,
  ];
  final values4 = [0.2, 0.4, 0.2];
  final values5 = [
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
    90.00,
  ];
  final calculator = DixonCalculator.instance;

  group('calculateQTest', () {
    group('with confidence of 95%', () {
      test('should return a valid Q Test result when using list values1', () {
        final results = calculator.calculate(
          values: values1.toSet(),
          confidence: Confidence.percent95,
        );

        expect(
          results.values.length,
          equals(7),
          reason: 'The number of values must be 7 after removing the outlier.',
        );
        expect(
          results.n,
          equals(7),
          reason: 'The original number of values must be 7.',
        );
        expect(
          results.lowerEnd.toStringAsFixed(4),
          equals('0.1531'),
          reason: 'The lower bound value is incorrect.',
        );
        expect(
          results.upperEnd.toStringAsFixed(4),
          equals('0.0017'),
          reason: 'The upper bound value is incorrect.',
        );
        expect(
          results.removedValues.length,
          equals(1),
          reason: 'One outlier must be removed.',
        );
        expect(
          results.removedValues,
          equals([1.9]),
          reason: 'The removed value must be 1.9.',
        );
        expect(results.q, equals(0.569), reason: 'The Q value is incorrect.');
      });

      test('should throw a DixonException when using list values2', () {
        expect(
          () => calculator.calculate(
            values: values2.toSet(),
            confidence: Confidence.percent95,
          ),
          throwsA(TypeMatcher<DixonException>()),
          reason:
              'Should throw a Dixon exception due to the inadequate size of the data.',
        );
      });

      test('should return a valid Q Test result when using list values3', () {
        final results = calculator.calculate(
          values: values3.toSet(),
          confidence: Confidence.percent95,
        );

        expect(
          results.values.length,
          equals(20),
          reason: 'The number of values must be 20.',
        );
        expect(
          results.n,
          equals(20),
          reason: 'The original number of values must be 20.',
        );
        expect(
          results.lowerEnd.toStringAsFixed(4),
          equals('0.0854'),
          reason: 'The lower bound value is incorrect.',
        );
        expect(
          results.upperEnd.toStringAsFixed(4),
          equals('0.1972'),
          reason: 'The upper bound value is incorrect.',
        );
        expect(
          results.removedValues.length,
          equals(0),
          reason: 'No outlier should be removed.',
        );
        expect(
          results.removedValues,
          equals([]),
          reason: 'The list of removed values must be empty.',
        );
      });

      test('should throw a DixonException when using list values4', () {
        expect(
          () => calculator.calculate(
            values: values4.toSet(),
            confidence: Confidence.percent95,
          ),
          throwsA(TypeMatcher<DixonException>()),
          reason:
              'Should throw a Dixon exception due to the inadequate size of the data.',
        );
      });

      test('should return a valid Q Test result when using list values5', () {
        final results = calculator.calculate(
          values: values5.toSet(),
          confidence: Confidence.percent95,
        );

        expect(
          results.values.length,
          equals(14),
          reason: 'The number of values must be 14.',
        );
        expect(
          results.n,
          equals(14),
          reason: 'The original number of values must be 14.',
        );
        expect(
          results.lowerEnd.toStringAsFixed(4),
          equals('0.1190'),
          reason: 'The lower bound value is incorrect.',
        );
        expect(
          results.upperEnd.toStringAsFixed(4),
          equals('0.4714'),
          reason: 'The upper bound value is incorrect.',
        );
        expect(
          results.removedValues.length,
          equals(0),
          reason: 'No outlier should be removed.',
        );
        expect(
          results.removedValues,
          equals([]),
          reason: 'The list of removed values must be empty.',
        );
      });
    });

    group('with confidence of 99%', () {
      test('should return a valid Q Test result when using list values1', () {
        final results = calculator.calculate(
          values: values1.toSet(),
          confidence: Confidence.percent99,
        );

        expect(
          results.values.length,
          equals(8),
          reason: 'The number of values must be 8.',
        );
        expect(
          results.n,
          equals(8),
          reason: 'The original number of values must be 8.',
        );
        expect(
          results.lowerEnd.toStringAsFixed(4),
          equals('0.1531'),
          reason: 'The lower bound value is incorrect.',
        );
        expect(
          results.upperEnd.toStringAsFixed(4),
          equals('0.6468'),
          reason: 'The upper bound value is incorrect.',
        );
        expect(
          results.removedValues.length,
          equals(0),
          reason: 'No outlier should be removed.',
        );
        expect(
          results.removedValues,
          equals([]),
          reason: 'The list of removed values must be empty.',
        );
        expect(results.q, equals(0.717), reason: 'The Q value is incorrect.');
      });

      test('should throw a DixonException when using list values2', () {
        expect(
          () => calculator.calculate(
            values: values2.toSet(),
            confidence: Confidence.percent99,
          ),
          throwsA(TypeMatcher<DixonException>()),
          reason:
              'Should throw a Dixon exception due to the inadequate size of the data.',
        );
      });

      test('should return a valid Q Test result when using list values3', () {
        final results = calculator.calculate(
          values: values3.toSet(),
          confidence: Confidence.percent99,
        );

        expect(
          results.values.length,
          equals(20),
          reason: 'The number of values must be 20.',
        );
        expect(
          results.n,
          equals(20),
          reason: 'The original number of values must be 20.',
        );
        expect(
          results.lowerEnd.toStringAsFixed(4),
          equals('0.0854'),
          reason: 'The lower bound value is incorrect.',
        );
        expect(
          results.upperEnd.toStringAsFixed(4),
          equals('0.1972'),
          reason: 'The upper bound value is incorrect.',
        );
        expect(
          results.removedValues.length,
          equals(0),
          reason: 'No outlier should be removed.',
        );
        expect(
          results.removedValues,
          equals([]),
          reason: 'The list of removed values must be empty.',
        );
      });

      test('should throw a DixonException when using list values4', () {
        expect(
          () => calculator.calculate(
            values: values4.toSet(),
            confidence: Confidence.percent99,
          ),
          throwsA(TypeMatcher<DixonException>()),
          reason:
              'Should throw a Dixon exception due to the inadequate size of the data.',
        );
      });

      test('should return a valid Q Test result when using list values5', () {
        final results = calculator.calculate(
          values: values5.toSet(),
          confidence: Confidence.percent99,
        );

        expect(
          results.values.length,
          equals(14),
          reason: 'The number of values must be 14.',
        );
        expect(
          results.n,
          equals(14),
          reason: 'The original number of values must be 14.',
        );
        expect(
          results.lowerEnd.toStringAsFixed(4),
          equals('0.1190'),
          reason: 'The lower bound value is incorrect.',
        );
        expect(
          results.upperEnd.toStringAsFixed(4),
          equals('0.4714'),
          reason: 'The upper bound value is incorrect.',
        );
        expect(
          results.removedValues.length,
          equals(0),
          reason: 'No outlier should be removed.',
        );
        expect(
          results.removedValues,
          equals([]),
          reason: 'The list of removed values must be empty.',
        );
      });
    });
  });
}
