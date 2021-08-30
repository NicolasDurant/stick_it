import 'package:example/routes.dart';
import 'package:example/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stick It Example App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: Home.routeName,
      routes: routes,
    );
  }
}
