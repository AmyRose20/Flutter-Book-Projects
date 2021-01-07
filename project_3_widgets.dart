import 'package:flutter/material.dart';

// typedef can be used as a pointer that references a function
typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  /* When creating an instance of ProductivityButton, you
  can use the syntax ProductivityButton(color: Colors.blueAccent,
  text: 'Hello World', onPressed: doSomething, size: 150).
  As named parameters are referenced by name, they can be
  used in any order.
  Named parameters are optional, but you can annotate them
  with the @required annotation to indicate that the
  parameter is mandatory. */
  ProductivityButton({@required this.color,
    @required this.text,
    @required this.onPressed,
    this.size});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: Text(
          this.text,
          style: TextStyle(color: Colors.white)),
        onPressed: this.onPressed,
        color: this.color,
        minWidth: this.size,
    );
  }
}

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final String setting;
  final CallbackSetting callback;
  SettingsButton(this.color, this.text, this.value, this.setting, this.callback);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(this.text,
          style: TextStyle(color: Colors.white)),
      /* The onPressed property contains the callback of the method
      that gets passed, with the setting and value parameters. This
      is a very powerful approach that allows you to pass methods
      as parameters, including their arguments. */
      onPressed: () => this.callback(this.setting, this.value),
      color: this.color,
    );
  }
}
