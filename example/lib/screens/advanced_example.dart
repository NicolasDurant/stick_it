import 'dart:io';

import 'package:example/components/circular_icon_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stick_it/stick_it.dart';
import 'package:uuid/uuid.dart';

class AdvancedExample extends StatefulWidget {
  AdvancedExample({Key? key}) : super(key: key);
  static String routeName = 'advanced-example';
  static String routeTitle = 'Advanced Example';

  @override
  _AdvancedExampleState createState() => _AdvancedExampleState();
}

class _AdvancedExampleState extends State<AdvancedExample> {
  /// background image of the stick it class
  final String _background =
      'https://images.unsplash.com/photo-1545147986-a9d6f2ab03b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=934&q=80';

  /// used for getting images either from gallery or camera
  final _picker = ImagePicker();

  /// reference used for calling the exportImage function
  late StickIt _stickIt;

  /// the image picked by a user as file
  File? _image;

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).size.height / 4;
    double rightPadding = MediaQuery.of(context).size.width / 12;
    double boxSize = 56.0;
    _stickIt = StickIt(
      child: _image == null ? Image.network(_background) : Image.file(_image!, fit: BoxFit.cover),
      stickerList: [
        Image.asset(
          'assets/icons8-anubis-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
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
      key: UniqueKey(),
      panelHeight: 175,
      panelBackgroundColor: Colors.white,
      panelStickerBackgroundColor: Theme.of(context).primaryColorLight,
      stickerSize: 100,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AdvancedExample.routeTitle),
      ),
      body: Stack(
        children: [
          _stickIt,
          Positioned(
            bottom: bottomPadding,
            right: rightPadding,
            child: Column(
              children: [
                ////////////////////////////////////////////////////////
                //               SAVE IMAGE TO GALLERY                //
                ////////////////////////////////////////////////////////
                CircularIconButton(
                  onTap: () async {
                    final image = await _stickIt.exportImage();
                    final directory = await getApplicationDocumentsDirectory();
                    final path = directory.path;
                    final uniqueIdentifier = Uuid().v1();
                    final file = await new File('$path/$uniqueIdentifier.png').create();
                    file.writeAsBytesSync(image);
                    GallerySaver.saveImage(file.path, albumName: 'Stick It').then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Image saved in the gallery album 'Stick It', go take a look!"),
                      ));
                    });
                  },
                  boxColor: Theme.of(context).primaryColorDark,
                  boxWidth: boxSize,
                  boxHeight: boxSize,
                  iconWidget: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                ////////////////////////////////////////////////////////
                //                  SELECT BACKGROUND                 //
                ////////////////////////////////////////////////////////
                CircularIconButton(
                  onTap: () {
                    generateModal(context);
                  },
                  boxWidth: boxSize,
                  boxHeight: boxSize,
                  iconWidget: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                  boxColor: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Method that either opens the gallery to pick an image or the camera to take a photo.
  /// Requires a [ImageSource] for the wanted selection. Updates listeners when a photo got selected.
  Future getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  /// Generates a modal in which the user can either pick a picture from
  /// gallery or create a pic with the camera of the mobile phone.
  void generateModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 128,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ////////////////////////////////////////////////////////
                //                  IMAGE FROM GALLERY                //
                ////////////////////////////////////////////////////////
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          child: Text('Select img from gallery'),
                          width: 200,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                  indent: 64,
                  endIndent: 64,
                ),
                ////////////////////////////////////////////////////////
                //                 IMAGE FROM CAMERA                  //
                ////////////////////////////////////////////////////////
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          child: Text('Select img from camera'),
                          width: 200,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
