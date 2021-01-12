import 'package:flutter/material.dart';
import './pong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
              title: Text('Simple Pong'),
          ),
      /* SafeArea automatically adds some padding to its
      child in order to avoid intrusions. */
      body: SafeArea(
        child: Pong()
      )
      )
    );
  }
}


