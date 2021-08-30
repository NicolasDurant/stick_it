# Stick It

Stick It is a fork of [flutter_simple_sticker_view](https://pub.dev/packages/flutter_simple_sticker_view). 

Attach stickers on another image. Stickers can be moved, scaled and now also rotated. Export your created composition as image.
This package supports null safety and comes with better documentation.

![Simplest Example](https://github.com/NicolasDurant/stick_it/blob/main/example/assets/Simulator%20Screen%20Recording%20-%20iPhone%2012%20Pro%20Max%20-%202021-08-30%20at%2015.36.09.gif)
![Advanced Example](https://github.com/NicolasDurant/stick_it/blob/main/example/assets/Simulator%20Screen%20Recording%20-%20iPhone%2012%20Pro%20Max%20-%202021-08-30%20at%2015.37.08.gif)

## Getting Started

Add [stick_it](https://pub.dev/packages/stick_it) as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
You can also check the [installing page](https://pub.dev/packages/stick_it/install).
Check out the [example page](https://pub.dev/packages/stick_it/example) for an advanced example with background image picker, image export, image save and custom settings.

## Usage

Import the library via
```dart
import 'package:stick_it/stick_it.dart';
```

### Simplest Example
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

## Supported Parameters
| named parameter             | type           | required | default                                           | description                                                                                                                                                                                                                                                                                        |
|-----------------------------|----------------|----------|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| child                       | Widget         | yes      |                                                   | Content you wish to place stickers upon                                                                                                                                                                                                                                                            |
| stickerList                 | List <Image>   | yes      |                                                   | List of sticker images that should be shown within the bottom panel. Those can be placed on top of your child Widget.                                                                                                                                                                              |
| devicePixelRatio            | double         | no       | 3.0                                               | The devices pixel ratio. See also: <https://stackoverflow.com/questions/8785643/what-exactly-is-device-pixel-ratio>                                                                                                                                                                                |
| panelBackgroundColor        | Color          | no       | Colors.black                                      | Background color of the bottom panel.                                                                                                                                                                                                                                                              |
| panelHeight                 | double         | no       | 200.0                                             | Height of the bottom panel.                                                                                                                                                                                                                                                                        |
| panelStickerBackgroundColor | Color          | no       | Colors.white10                                    | Background color of the container stickers are placed within.                                                                                                                                                                                                                                      |
| panelStickerCrossAxisCount  | int            | no       | 4                                                 | Defines how many stickers are placed within one row of the grid.                                                                                                                                                                                                                                   |
| panelStickerAspectRatio     | double         | no       | 1.0                                               | Ratio of the cross-axis to the main-axis extent of each child.                                                                                                                                                                                                                                     |
| stickerMaxScale             | double         | no       | 2.0                                               | Maximal scaling ratio for your stickers. E.g 2 will allow the sticker to be twice as big!                                                                                                                                                                                                          |
| stickerMinScale             | double         | no       | 0.5                                               | Minimal scaling ratio for your stickers.E.g 0.5 will allow the sticker to be half as big at minimum!                                                                                                                                                                                               |
| stickerRotatable            | bool           | no       | true                                              | Controls whether your stickers should be rotatable, while the scaling event is active.Set to false, if you don't want rotation.                                                                                                                                                                    |
| stickerSize                 | double         | no       | 100.0                                             | Size of the [Rect] the stickers are on when placed within the [Stack]. Setting this value up will only increase the [Rect] size. So, to display them bigger when placing on the [child] you will have to set something like fit: Boxfit.cover on the image you are providing in the [stickerList]. |
| viewPort                    | Size           | no       | Size(constraints.maxWidth, constraints.maxHeight) | [Size] of the viewport that is provided.You don't have to set this manually, it will take the available space per default.                                                                                                                                                                         |

## Supported Methods
| function name | returns           | description                                                                                                                                                             |
|---------------|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| exportImage() | Future<Uint8List> | Creates an [Uint8List] out of your composition, that you can use to save as [Image].Before that it will clear all selections, so they don't appear on the new creation. |