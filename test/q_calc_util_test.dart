import 'package:q_calc_util/q_calc_util.dart';
import 'package:test/test.dart';

void main() {
  group('95% confidence tests', () {
    test('Q should be equals 0.569', () {
      List<double> values = [0.988, 0.978, 0.8, 0.987, 0.4, 1.9, 0.49, 0.87];
      DixonResults results = calculateQTest(values, Confidence.percent95);
      expect(results.q, equals(0.569));
    });

    test('Calculation should be reproved', () {
      List<double> values = [0.2, 0.4, 0.2];
      try {
        DixonResults results = calculateQTest(values, Confidence.percent95);
      } catch (error) {
        expect(error is DixonException, true);
      }
    });

    test('Q should be equals 0.569', () {
      List<double> values = [0.988, 0.978, 0.8, 0.987, 0.4, 1.9, 0.49, 0.87];
      DixonResults results = calculateQTest(values, Confidence.percent99);
      expect(results.q, equals(0.717));
    });

    test('Calculation should be reproved', () {
      List<double> values = [0.2, 0.4, 0.2];
      try {
        DixonResults results = calculateQTest(values, Confidence.percent99);
      } catch (error) {
        expect(error is DixonException, true);
      }
    });
  });
}
