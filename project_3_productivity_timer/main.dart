import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import './widgets.dart';
import './timer.dart';
import './timermodel.dart';
import './settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Work Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TimerHomePage(),
    );
  }
}


class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5.0;
  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {

    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    timer.startWork();

    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('My Work Timer'),
            actions: [
            PopupMenuButton<String>(
              // itemBuilder property can show a list of PopupMenuItems
              itemBuilder: (BuildContext context) {
                return menuItems.toList();
              },
              onSelected: (s) {
                if(s=='Settings') {
                  goToSettings(context);
                }
              },
          )
        ],
          ),
          /* A LayoutBuilder provides the parent widget's constraints, so that
          you can find out how much space you have for your widgets. */
          body: LayoutBuilder(
            /* Find available width by calling the 'maxWidth' property of the
            'BoxConstraints' instance and put it in 'availableWidth' constant. */
            builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            return Column(children: [
              Row(
                children: [
                  // WORK BUTTON
                  // Each button will have a leading and trailing padding.
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  /* Expanded widget in this scenario, makes the buttons
                  in the row take up the available horizontal space. */
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff009688),
                          text: "Work",
                          /* In Dart and Flutter, you can pass a function as a parameter,
                          in a constructor or any other method. */
                          onPressed: () => timer.startWork())),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  // SHORT BREAK BUTTON
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff607D8B),
                          text: "Short Break",
                          onPressed: () => timer.startBreak(true))),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  // LONG BREAK BUTTON
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff455A64),
                          text: "Long Break",
                          onPressed:() => timer.startBreak(false))),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              ),
              /* Expanded is used in a column instead of the row,
              so it takes all the available space/ takes all the
              vertical space in the column. */
              Expanded(
                  /* StreamBuilder is used to listen to events that
                  come from Streams. A StreamBuilder rebuilds its
                  children at any change in the Stream. */
                  child: StreamBuilder(
                      initialData: TimerModel('00:00', 1),
                      stream: timer.stream(),
                      /* AsyncSnapshot contains the data of the most recent
                      interaction with a StreamBuilder. */
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        /* 'data' is what was received from the *yield in the
                        stream() method of the CountdownTimer class, which
                        returned a TimerModel object. */
                        TimerModel timer = snapshot.data;
                        return Container(
                            /* CircularPercentIndicator placed in an Expanded widget so that
                            it takes all the available space in the column. */
                            child: CircularPercentIndicator(
                                /* For the radius size, choose a
                                relative size that depends on the
                                available space on the screen. */
                                radius: availableWidth / 2,
                                lineWidth: 10.0,
                                percent: (timer.percent == null) ? 1 : timer.percent,
                                center: Text( (timer.time == null) ? '00:00' : timer.time ,
                                          style: Theme.of(context).textTheme.headline4),
                                progressColor: Color(0xff009688),
                        ));
                      })
              ),
              Row(
                children: [
                  // STOP BUTTON
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff212121),
                          text: 'Stop',
                          onPressed: () => timer.stopTimer())),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                  // START BUTTON
                  Expanded(
                      child: ProductivityButton(
                          color: Color(0xff009688),
                          text: 'Restart',
                          onPressed: () => timer.startTimer())),
                  Padding(
                    padding: EdgeInsets.all(defaultPadding),
                  ),
                ],
              )
            ]);
          })),
    );
  }

  void emptyMethod() {}
  void goToSettings(BuildContext context) {
    print('in gotoSettings');
    // whenever you need to change screens, use the Navigator object
    Navigator.push(
        /* When you want to use push(), you need to specify a route,
        which is the screen you want to load. For that purpose you use
        the MaterialPageRoute class, in which you specify the name of the
        Page you want to push. Requires a context too. */
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}



