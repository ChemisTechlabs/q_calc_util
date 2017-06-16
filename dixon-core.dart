/*
	Copyright 2013-2014 ChemisProject

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.*/

final Map<String,double> dixonConstants = {
	'95_3': 0.970,
	'95_4': 0.829,
	'95_5': 0.710,
	'95_6': 0.628,
	'95_7': 0.569,

	'95_8': 0.608,
	'95_9': 0.564,
	'95_10': 0.530,
	'95_11': 0.502,
	'95_12': 0.479,

	'95_13': 0.611,
	'95_14': 0.586,
	'95_15': 0.565,
	'95_16': 0.546,
	'95_17': 0.529,
	'95_18': 0.514,
	'95_19': 0.501,
	'95_20': 0.489,
	'95_21': 0.478,
	'95_22': 0.468,
	'95_23': 0.459,
	'95_24': 0.451,
	'95_25': 0.443,
	'95_26': 0.436,
	'95_27': 0.429,
	'95_28': 0.423,
	'95_29': 0.417,
	'95_30': 0.412,

	//99% constants
	'99_3': 0.994,
	'99_4': 0.926,
	'99_5': 0.821,
	'99_6': 0.740,
	'99_7': 0.608,

	'99_8': 0.717,
	'99_9': 0.672,
	'99_10': 0.635,
	'99_11': 0.605,
	'99_12': 0.579,

	'99_13': 0.697,
	'99_14': 0.670,
	'99_15': 0.647,
	'99_16': 0.627,
	'99_17': 0.610,
	'99_18': 0.594,
	'99_19': 0.580,
	'99_20': 0.567,
	'99_21': 0.555,
	'99_22': 0.544,
	'99_23': 0.535,
	'99_24': 0.526,
	'99_25': 0.517,
	'99_26': 0.510,
	'99_27': 0.502,
	'99_28': 0.495,
	'99_29': 0.489,
	'99_30': 0.483
};

class Dixon {
	List<double> _values = new List<double>();
  List<double> _removed = new List<double>();

  Dixon (){
    print("Dixon Object initialized");
  }

  List<double> get values => _values;

  List<double> get remove => _removed;

  //Adds a value to values list only if doesn't exist
  void addValue(double value) {
    if(_values.indexOf(value)==-1) _values.add(value);
  }

  //Removes a value from values list at given index and adds it to removed list
  void removeValueAt(int index) => _removed.add(_values.removeAt(index));

  //Removes the given value from values list and add it to removed list
  void removeValue(double value){
    _values.removeWhere((someValue){
      if(value==someValue){
        _removed.add(value);
        return true;
      }else{
        return false;
      }
    });
  }

  //Returns a double value from values list stored in the given index
  double getValueAt(int index) => _values.elementAt(index);

  //Returns the first double value from values list
  double getFirstValue() => _values.first;

  //Removes the first double values from values list and returns it
  double removeFirstValue() => _values.removeAt(0);

  //Returns the last double value from values list
  double getLastValue() => _values.last;

  //Removes the last double value from values list and returns it
  double removeLastValue() => _values.removeLast();

  //Sorts values from values list in ascending order
  void sortValues() => _values.sort();

  //Returns the N value of Dixon formula, equivalent to values list length
  int getN() => _values.length;

  //Clears values list
  void clear() => _values.clear();
}

class DixonException implements Exception {
  //A message describing the Dixon error.
  final String message;

  //Creates a new DixonException with an optional error [message].
	const DixonException([this.message = "Unknown error"]);

	String toString() => "Chemis Dixon Exception: $message";
}

class DixonControl {

  static bool approved(double value,int percent,Dixon dixon) {
    return (value < dixonConstants["$percent\_${dixon.getN()}"]);
  }

  //lower end functions
  static double getLowerEnd3_7(List<double> values) {
    return (values[1] - values[0]) / (values[values.length - 1] - values[0]);
  }

  static double getLowerEnd8_12(List<double> values) {
    return (values[1] - values[0]) / (values[values.length - 2] - values[0]);
  }

  static double getLowerEnd13(List<double> values) {
    return (values[2] - values[0]) / (values[values.length - 3] - values[0]);
  }

  //Upper end functions
  static double getUpperEnd3_7(List<double> values) {
    return (values[values.length - 1] - values[values.length - 2]) / (values[values.length - 1] - values[0]);
  }

  static double getUpperEnd8_12(List<double> values) {
    return (values[values.length - 1] - values[values.length - 2]) / (values[values.length - 1] - values[1]);
  }

  static double getUpperEnd13(List<double> values) {
    return (values[values.length - 1] - values[values.length - 3]) / (values[values.length - 1] - values[2]);
  }

  static DixonResults recursiveCalc(Dixon dixonObj,DixonResults resultsObj) {
    double lowerEnd = 0.0;
    double upperEnd = 0.0;

    if (dixonObj.getN() < 3) {
      throw new DixonException("'n' is lower than 3");
    } else if (dixonObj.getN() >= 3 && dixonObj.getN() <= 7) {
      lowerEnd = DixonControl.getLowerEnd3_7(dixonObj.values);
      upperEnd = DixonControl.getUpperEnd3_7(dixonObj.values);
    } else if (dixonObj.getN() >= 8 && dixonObj.getN() <= 12) {
      lowerEnd = DixonControl.getLowerEnd8_12(dixonObj.values);
      upperEnd = DixonControl.getUpperEnd8_12(dixonObj.values);
    } else if (dixonObj.getN() >= 13) {
      lowerEnd = DixonControl.getLowerEnd13(dixonObj.values);
      upperEnd = DixonControl.getUpperEnd13(dixonObj.values);
    }

    if (DixonControl.approved(lowerEnd, resultsObj.percent, dixonObj)) {
      resultsObj.lowerEnd = lowerEnd;
    } else {
      dixonObj.removeFirstValue();
      resultsObj.lowerEnd = DixonControl.recursiveCalc(dixonObj, resultsObj).lowerEnd;
    }

    if (DixonControl.approved(upperEnd, resultsObj.percent, dixonObj)) {
      resultsObj.upperEnd = upperEnd;
    } else {
      dixonObj.removeLastValue();
      resultsObj.upperEnd = DixonControl.recursiveCalc(dixonObj, resultsObj).upperEnd;
    }

    return resultsObj;
  }

  static DixonResults calc(Dixon dixonObj,int percent) {
    dixonObj.sortValues();
    return DixonControl.recursiveCalc(dixonObj, new DixonResults(percent));
  }
}

class DixonResults {
  double _lowerEnd=0.0;
  double _upperEnd=0.0;
  int _percent=0;

  DixonResults(this._percent);

  double get lowerEnd => _lowerEnd;

  set lowerEnd(double value) {
    _lowerEnd = value;
  }

  double get upperEnd => _upperEnd;

  set upperEnd(double value) {
    _upperEnd = value;
  }

  int get percent => _percent;
}

class DixonRegister {
  final DateTime date = new DateTime.now();
  String _name;
	final List<double> _values;
	final DixonResults _result95;
	final DixonResults _dixon95;
	final DixonResults _result99;
	final DixonResults _dixon99;

  DixonRegister(this._name, this._values, this._result95, this._dixon95,
      this._result99, this._dixon99);

  DixonResults get dixon99 => _dixon99;

  DixonResults get result99 => _result99;

  DixonResults get dixon95 => _dixon95;

  DixonResults get result95 => _result95;

  List<double> get values => _values;

  String get name => _name;

  set name(String value){
    _name = name;
  }
}

class DixonHistory {
	List<DixonRegister> _registers = new List<DixonRegister>();

  List<DixonRegister> get registers => _registers;

  //Adds a new calculation register to registers list
  void addRegister(DixonRegister register) => _registers.add(register);

  //Returns a register object based in the given date
  DixonRegister getRegister(DateTime dateTime){
    return _registers.singleWhere((DixonRegister register){
      return register.date.isAtSameMomentAs(dateTime);
    });
  }
}