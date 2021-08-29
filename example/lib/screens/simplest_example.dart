import 'package:flutter/material.dart';
import 'package:stick_it/stick_it.dart';

class SimplestExample extends StatelessWidget {
  const SimplestExample({Key? key}) : super(key: key);
  static String routeName = 'simplest-example';
  static String routeTitle = 'Simplest Example';
  final String _background =
      'https://images.unsplash.com/photo-1545147986-a9d6f2ab03b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routeTitle),
      ),
      body: StickIt(stickerList: [],
      child: null,)
    );
  }
}
