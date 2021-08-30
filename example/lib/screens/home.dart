import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  static String routeName = 'home';
  static String routeTitle = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(routeTitle),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('simplest-example');
                },
                child: Text('Simplest Example'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('advanced-example');
                },
                child: Text('Advanced Example'),
              ),
            ],
          ),
        ));
  }
}
