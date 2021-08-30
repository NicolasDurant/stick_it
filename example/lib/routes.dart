import 'package:example/screens/advanced_example.dart';
import 'package:example/screens/home.dart';
import 'package:example/screens/simplest_example.dart';
import 'package:flutter/material.dart';

/// To further simplify the main.dart file, a separate routes.dart file should exist which only holds the Map<String, WidgetBuilder> as a simple map of all of the app’s routes.
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  AdvancedExample.routeName: (BuildContext context) => AdvancedExample(),
  Home.routeName: (BuildContext context) => Home(),
  SimplestExample.routeName: (BuildContext context) => SimplestExample(),
};
