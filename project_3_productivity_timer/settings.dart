import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        // calling Settings widget
        body: Settings());
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // TextEditingController is an effective way of reading and writing data
  TextEditingController txtWork;
  TextEditingController txtShort;
  TextEditingController txtLong;

  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  int workTime;
  int shortBreak;
  int longBreak;
  SharedPreferences prefs;

  @override
  void initState() {
    /* Here we are creating the objects that will allow us to
    read from and write to the TextField widgets */
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24);
    return Container(
        child: GridView.count(
          /* If the content of the GridView is bigger than the
          available space, the content will scroll vertically. */
          scrollDirection: Axis.vertical,
          // number of items that will appear on each row
          crossAxisCount: 3,
          // size for the children in the GridView
          /* By setting 3, we are saying that the width must be
          3 times the height */
          childAspectRatio: 3,
          // no space between the children of the GridView by default
          // add some using mainAxisSpacing
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            // ROW 1
            Text("Work", style: textStyle),
            /* The two empty texts are just to make sure that the following
            widget will end up in the second row. */
            Text(""),
            Text(""),
            // ROW 2
            SettingsButton(Color(0xff455A64), "-", -1, WORKTIME, updateSetting),
            TextField(
                style: textStyle,
                controller: txtWork,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number),
            SettingsButton(Color(0xff009688), "+", 1, WORKTIME, updateSetting),
            // ROW 3
            Text("Short", style: textStyle),
            Text(""),
            Text(""),
            // ROW 4
            SettingsButton(Color(0xff455A64), "-", -1, SHORTBREAK, updateSetting),
            TextField(
                style: textStyle,
                textAlign: TextAlign.center,
                controller: txtShort,
                keyboardType: TextInputType.number),
            SettingsButton(Color(0xff009688), "+", 1, SHORTBREAK, updateSetting),
            // ROW 5
            Text(
              "Long",
              style: textStyle,
            ),
            Text(""),
            Text(""),
            // ROW 6
            SettingsButton( Color(0xff455A64), "-",-1, LONGBREAK, updateSetting
            ),
            TextField(
                style: textStyle,
                textAlign: TextAlign.center,
                controller: txtLong,
                keyboardType: TextInputType.number),
            SettingsButton(Color(0xff009688), "+", 1, LONGBREAK, updateSetting),
          ],
          padding: const EdgeInsets.all(20.0),
        ));
  }

  /* This function reads the value of the settings from SharedPreferences
  and then it writes the values in the TextFields. */
  readSettings() async {
    /* Use await statement to make sure prefs get
    instantiated before the next lines of code are executed. */
    prefs = await SharedPreferences.getInstance();
    int workTime = prefs.getInt(WORKTIME);
    if (workTime==null) {
      await prefs.setInt(WORKTIME, int.parse('30'));
    }
    int shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak==null) {
      await prefs.setInt(SHORTBREAK, int.parse('5'));
    }
    int longBreak = prefs.getInt(LONGBREAK);
    if (longBreak==null) {
      await prefs.setInt(LONGBREAK, int.parse('20'));
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  /* This method reads the value of the key that was
  passed and adds the value (+1 or -1). */
  void updateSetting(String key, int value) {
    // the key is one of the constants declared at the top of the class
    switch (key) {
      case WORKTIME:
        {
          int workTime = prefs.getInt(WORKTIME);
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            // updates the key that was passed
            prefs.setInt(WORKTIME, workTime);
            // updates the text property of the text controller
            setState(() {
              txtWork.text = workTime.toString();
            });
          }
        }
        break;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK);
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() {
              txtShort.text = short.toString();
            });
          }
        }
        break;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK);
          long += value;
          if (long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() {
              txtLong.text = long.toString();
            });
          }
        }
        break;
    }
  }
}