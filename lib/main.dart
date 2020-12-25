import 'package:flutter/material.dart';
import 'package:ungfunny/states/authen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authen(),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}
