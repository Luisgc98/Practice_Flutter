import 'package:ejemplo1/sqlite/models.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo1/main/home.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.black,
        ),
        focusColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext) => Home(),
      },
      home: Home(),
    );
  }
}