import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/* Stateful widget overrides a createState()
method, which returns a State. */
class MyApp extends StatefulWidget
{
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>
{
  double _numberFrom;
  final List<String> _measures = ['meters', 'kilometers', 'grams',
  'kilograms', 'feet', 'miles', 'pounds (lbs)', 'ounces'];
  // will contain the selected value from DropdownButton
  String _startMeasure;
  String _convertedMeasure;
  /* Maps allow you to insert key-value pairs, where the first element
  is the key and the second is the value. When you need to retrieve a
  value from Map, you can use the following syntax:
  myValue = measures['miles'];
  where myValue will have a value of 5. */
  final Map<String, int> _measuresMap = {
    'meters' : 0,
    'kilometers' : 1,
    'grams' : 2,
    'kilograms' : 3,
    'feet' : 4,
    'miles' : 5,
    'pounds (lbs)' : 6,
    'ounces' : 7,
  };
  final dynamic _formulas = {
    '0' : [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1' : [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2' : [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3' : [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4' : [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5' : [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6' : [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7' : [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };
  String _resultMessage;

  @override
  Widget build(BuildContext context)
  {
    // for TextFields, DropDownButtons and Button
    final TextStyle inputStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[900],
    );

    // for Text
    final TextStyle labelStyle = TextStyle(
      fontSize: 24,
      color: Colors.grey[700],
    );

    return MaterialApp(
      title: 'Measures Converter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Measures Converter')
        ),
        // Container takes a padding of 20 logical pixels
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /* Spacer() creates an empty space that can be used to set spacing
                between widgets in a flexible container, such as the Column
                in our interface. Spacer has a 'flex' property with a default
                value of 1. */
                Spacer(),
                Text(
                  'Value',
                  style: labelStyle,
                ),
                Spacer(),

                TextField(
                  style: inputStyle,
                  /* decoration property takes an InputDecoration object.
                  InputDecoration allows you to specify the border,
                  labels, icons and styles that will be used to decorate
                  a text field. */
                  decoration: InputDecoration(
                    hintText: "Please insert the measure to be converted",
                  ),
                  onChanged: (text) {
                    // tryParse() checks whether the value typed is a number
                    var rv = double.tryParse(text);
                    if(rv != null) {
                      setState(() {
                        _numberFrom = rv;
                      });
                    }
                  },
                ),

                Spacer(),
                Text(
                  'From',
                  style: labelStyle,
                ),
                Spacer(),

                DropdownButton(
                  isExpanded: true,
                  items: _measures.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      // update _startMeasure with the new value that is passed
                      _startMeasure = value;
                    });
                  },
                  value: _startMeasure,
                ),

                Spacer(),
                Text(
                  'To',
                  style: labelStyle,
                ),
                Spacer(),

                DropdownButton(
                  isExpanded: true,
                  style: inputStyle,
                  // items property requires a list of DropdownMenuItem widgets
                  /* map() iterates through all the values of the array. The
                  function inside map() returns a DropDownMenuItem widget which
                  has a 'value' and 'child' property. The 'child' is what
                  the user will see, the 'value' is used to retrieve the selected
                  item on the list. */
                  items: _measures.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                          style: inputStyle,
                      ),
                    );
                  }).toList(),
                  // respond to user actions by calling a function in onChanged() property
                  onChanged: (value){
                    setState(() {
                      _convertedMeasure = value;
                    });
                  },
                  value: _convertedMeasure,
                ),

                Spacer(flex: 2,),
                RaisedButton(
                    child: Text('Convert', style: inputStyle),
                    onPressed: () {
                      if(_startMeasure.isEmpty || _convertedMeasure.isEmpty || _numberFrom == 0) {
                          return;
                        }
                      else {
                          // call the convert method
                          convert(_numberFrom, _startMeasure, _convertedMeasure);
                        }
                    },
                ),
                Spacer(flex: 2,),
                // show result of conversion
                Text((_resultMessage == null) ? '' : _resultMessage,
                  style: labelStyle),
                Spacer(flex: 8,),
              ],
            ),
          ),
        )
      )
    );
  }

  @override
  void initState() {
    // put initial value of variable
    _numberFrom = 0;
    // always call super init.State() at the end of the initState() method
    super.initState();
  }

  // converts the formulas and the measures 'Map'
  void convert(double value, String from, String to) {
    int nFrom = _measuresMap[from];
    int nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    var result = value * multiplier;

    if(result == 0) {
        _resultMessage = 'This conversion cannot be performed';
      }
    else {
        _resultMessage = '${_numberFrom.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
      }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }
}
