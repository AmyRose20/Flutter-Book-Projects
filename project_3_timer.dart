import 'dart:async';
import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  // express the percentage of completed time
  double _radius = 1;
  // is counter active or not
  bool _isActive = true;
  // Timer is a class used to create countdown timers
  Timer timer;
  // Duration is used to contain a span of time
  // express the remaining time
  Duration _time;
  // beginning time
  Duration _fullTime;
  // default number of minutes for work
  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;

  get percent => null;

  String get time => null;

  void startWork() async
  {
    await readSettings();
    _radius = 1;
    // set to number of minutes contained in work variable
    _time = Duration(minutes: this.work, seconds: 0);
    _fullTime = _time;
  }

  String returnTime(Duration t) {
    /* If minutes have only 1 digit (< 10), we add a "0"
    before the minute (digit between 0 and 9), else do
    not concatenate a "0" and simply return the minutes. */
    String minutes = (t.inMinutes < 10) ? '0' +
    t.inMinutes.toString() :
        t.inMinutes.toString();
    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    /* If seconds have only 1 digit (< 10), we add a "0"
    before the second (digit between 0 and 9), else do
    not concatenate a "0" and simply return the seconds. */
    String seconds = (numSeconds < 10) ? '0' +
    numSeconds.toString() :
        numSeconds.toString();
    /* Concatenate the two values (minutes and seconds)
    with a ":" sign, and return in String format. */
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;

  }
  /* Function returns a Stream of TimerModel,
  decrementing the Duration every second. */
  // (*) is used to say that a Stream is being returned
  // stream() method returns a Stream
  /* You use async (without the * sign) for Futures
  ans async* (with the * sign) for Streams.
  What's the difference between a Stream and a Future?
  Any number of events can be returned in a Stream,
  whereas a future only returns once. */
  Stream<TimerModel> stream() async* {
    /* Yield is like a return statement, but it doesn't end the function.
    You use the "*" sign after yield because we are returning a Stream;
    if it were a single value, you would just use yield. */
    /* Stream.periodic is a constructor creating a Stream that
    emits events at the intervals specified in the first parameter. */
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if(this._isActive) {
        _time = _time - Duration(seconds: 1);
        // remaining time divided by the total time
        /* This value goes from 1 at the beginning
        of the countdown, to 0 at the end of the countdown. */
        _radius = _time.inSeconds / _fullTime.inSeconds;
        /* If _time is 0, change _isActive to false to stop
        * the countdown.  */
        if(_time.inSeconds <= 0) {
          _isActive = false;
        }
      }
      /* returnTime method is called to transform the remaining Duration
      int a String */
      time = returnTime(_time);
      return TimerModel(time, _radius);
    });
  }

  /* Method retrieves the settings saved in the SharedPreferences
  instance or sets default values. */
  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    shortBreak = prefs.getInt('shortBreak') == null ? 30 : prefs.getInt('shortBreak');
    longBreak = prefs.getInt('longBreak') == null ? 30 : prefs.getInt('longBreak');
  }

  void stopTimer() {
    this._isActive = false;
  }

  void startTimer() {
    if(_time.inSeconds > 0) {
      this._isActive = true;
    }
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(
        minutes: (isShort) ? shortBreak: longBreak,
        seconds: 0);
    _fullTime = _time;
  }
}
