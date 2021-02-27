import 'package:flutter/material.dart';
import 'package:ungfunny/states/authen.dart';
import 'package:ungfunny/states/test_location.dart';

String initialRoute = '/testLocation';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/testLocation':(BuildContext context)=>TestLocation(),
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
