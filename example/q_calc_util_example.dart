import 'package:q_calc_util/q_calc_util.dart';

void printResults(DixonResults result) {
  print("""
      Confidence: 95%
       Lower end: ${result.lowerEnd.toStringAsFixed(3)}
       Upper end: ${result.upperEnd.toStringAsFixed(3)}
               Q: ${result.q}
               N: ${result.n}
          Values: ${result.values.toString()}
  Removed values: ${result.removedValues.toString()}
  """);
}

main() {
  List<double> values = [0.764, 0.864, 0.936, 0.047, 1.028, 1.043];

  try {
    DixonResults result95 = calculateQTest(values, Confidence.percent95);
    printResults(result95);
  } on DixonException catch (error) {
    print(error.toString());
  }

  try {
    DixonResults result99 = calculateQTest(values, Confidence.percent99);
    printResults(result99);
  } on DixonException catch (error) {
    print(error.toString());
  }
}
