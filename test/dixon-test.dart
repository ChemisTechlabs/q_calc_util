import '../dixon-core.dart';

void main(){
  List<double> valuesFromFields=[0.764,0.864,0.936,0.047,1.028,1.043];

  Dixon dixon95=new Dixon();
  Dixon dixon99=new Dixon();

  valuesFromFields.forEach((value)=>dixon95.addValue(value));
  valuesFromFields.forEach((value)=>dixon99.addValue(value));

  DixonResults dixonResults95=DixonControl.calc(dixon95,95);
  DixonResults dixonResults99=DixonControl.calc(dixon99,99);


  print("Percentage: ${dixonResults95.percent}");
  print("Lower end: ${dixonResults95.lowerEnd.toStringAsFixed(4)}");
  print("Upper end: ${dixonResults95.upperEnd.toStringAsFixed(4)}");
  print("Q: ${dixon95.getQ(95).toStringAsFixed(3)}");
  print("Used values: ${dixon95.values.toString()}");
  print("Removed values: ${dixon95.removed.toString()}");

  print("===");

  print("Percentage: ${dixonResults99.percent}");
  print("Lower end: ${dixonResults99.lowerEnd.toStringAsFixed(4)}");
  print("Upper end: ${dixonResults99.upperEnd.toStringAsFixed(4)}");
  print("Q: ${dixon99.getQ(99).toStringAsFixed(3)}");
  print("Used values: ${dixon99.values.toString()}");
  print("Removed values: ${dixon99.removed.toString()}");
}