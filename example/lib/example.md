# Cookbook

All the snippets are from the [example project](https://github.com/NicolasDurant/stick_it/tree/main/lib/example).

## Simple Usage
![Simplest Example](https://github.com/NicolasDurant/stick_it/tree/main/assets/simplest-example.png)
```dart
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
      body: StickIt(
        /// The [StickIt] Class only requires two named parameters.
        ///
        /// [Widget] child - the child that the stickers should be placed upon.
        /// [List<Image>] stickerList - the list of stickers available to the user.
        ///
        /// StickIt supports a lot of styling related optional named parameters,
        /// that you can change and check out in the AdvancedExample. (tbd)
        child: Image.network(_background),
        stickerList: [
          Image.asset('assets/icons8-anubis-48.png'),
          Image.asset('assets/icons8-bt21-shooky-48.png'),
          Image.asset('assets/icons8-fire-48.png'),
          Image.asset('assets/icons8-jake-48.png'),
          Image.asset('assets/icons8-keiji-akaashi-48.png'),
          Image.asset('assets/icons8-mate-48.png'),
          Image.asset('assets/icons8-pagoda-48.png'),
          Image.asset('assets/icons8-spring-48.png'),
          Image.asset('assets/icons8-totoro-48.png'),
          Image.asset('assets/icons8-year-of-dragon-48.png'),
        ],
      ),
    );
  }
}
```

## Advanced Usage
tbd