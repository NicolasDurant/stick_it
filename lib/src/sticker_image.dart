import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vec;

typedef StickerImageRemoveCallback = void Function(StickerImage sticker);

class StickerImage extends StatefulWidget {
  StickerImage(
    this.image, {
    Key? key,
    required this.width,
    required this.height,
    required this.viewport,
    required this.minScale,
    required this.maxScale,
    required this.rotatable,
    required this.onTapRemove,
  }) : super(key: key);

  final Image image;
  final double height;
  final double minScale;
  final double maxScale;
  final bool rotatable;
  final Size viewport;
  final double width;

  final StickerImageRemoveCallback onTapRemove;

  final _StickerImageState _flutterSimpleStickerImageState = _StickerImageState();

  void prepareExport() {
    _flutterSimpleStickerImageState.hideRemoveButton();
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return "FlutterSimpleStickerImage-$key-${_flutterSimpleStickerImageState._offset}";
  }

  @override
  _StickerImageState createState() => _flutterSimpleStickerImageState;
}

class _StickerImageState extends State<StickerImage> {
  _StickerImageState();

  double _scale = 1.0;
  double _previousScale = 1.0;

  Offset _previousOffset = Offset(0, 0);
  Offset _startingFocalPoint = Offset(0, 0);
  Offset _offset = Offset(0, 0);

  double _rotation = 0.0;
  double _previousRotation = 0.0;

  bool _isSelected = false;

  @override
  void dispose() {
    super.dispose();
    _offset = Offset(0, 0);
    _scale = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: Rect.fromPoints(
        Offset(_offset.dx, _offset.dy),
        Offset(_offset.dx + widget.width, _offset.dy + widget.height),
      ),
      child: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: Transform(
                transform: Matrix4.diagonal3(vec.Vector3(_scale, _scale, _scale)),
                // ..setRotationZ(_rotation),
                alignment: FractionalOffset.center,
                child: Transform.rotate(
                  angle: _rotation,
                  child: GestureDetector(
                    onScaleStart: (ScaleStartDetails details) {
                      _startingFocalPoint = details.focalPoint;
                      _previousOffset = _offset;
                      _previousRotation = _rotation;
                      _previousScale = _scale;

                      // print(
                      //     "begin - focal : ${details.focalPoint}, local : ${details.localFocalPoint}");
                    },
                    onScaleUpdate: (ScaleUpdateDetails details) {
                      _scale = min(max(_previousScale * details.scale, widget.minScale), widget.maxScale);

                      if (details.rotation != 0.0 && widget.rotatable) {
                        _rotation = details.rotation;
                      }

                      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousScale;

                      Offset __offset = details.focalPoint - (normalizedOffset * _scale);

                      __offset = Offset(max(__offset.dx, -widget.width), max(__offset.dy, -widget.height));

                      __offset =
                          Offset(min(__offset.dx, widget.viewport.width), min(__offset.dy, widget.viewport.height));

                      setState(() {
                        _offset = __offset;
                        // print("move - $_offset, scale : $_scale");
                      });
                    },
                    onTap: () {
                      setState(() {
                        _isSelected = !_isSelected;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _isSelected = false;
                      });
                    },
                    onDoubleTap: () {
                      setState(() {
                        _scale = 1.0;
                      });
                    },
                    child: Container(child: widget.image),
                  ),
                ),
              ),
            ),
            _isSelected
                ? Positioned(
                    top: 12,
                    right: 12,
                    width: 24,
                    height: 24,
                    child: Container(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.remove_circle),
                        color: Color.fromRGBO(255, 0, 0, 1.0),
                        onPressed: () {
                          print('tapped remove sticker');
                          this.widget.onTapRemove(this.widget);
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void hideRemoveButton() {
    setState(() {
      _isSelected = false;
    });
  }
}
