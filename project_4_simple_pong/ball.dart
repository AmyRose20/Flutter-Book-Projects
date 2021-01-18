import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double diam = 50;
    /* When you create a container, the default shape is a rectangle.
    By specifying BoxShape.circle, you can avoid dealing with angles. */
    return Container(
        width: diam,
        height: diam,
        decoration: new BoxDecoration(
            color: Colors.amber[400],
            shape: BoxShape.circle,
        ),
    );
  }
}
