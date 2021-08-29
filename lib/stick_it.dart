library stick_it;

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stick_it/src/sticker_image.dart';

class StickIt extends StatefulWidget {
  StickIt(
      {Key? key,
      required this.child,
      required this.stickerList,
      this.devicePixelRatio = 3.0,
      this.panelHeight = 200.0,
      this.panelBackgroundColor = Colors.black,
      this.panelStickerBackgroundColor = Colors.white10,
      this.panelStickerCrossAxisCount = 4,
      this.panelStickerAspectRatio = 1.0,
      this.stickerRotatable = true,
      this.stickerSize = 100.0,
      this.stickerMaxScale = 2.0,
      this.stickerMinScale = 0.5,
      this.viewport = const Size(0.0, 0.0)})
      : super(key: key);
  final Widget child;
  final List<Image> stickerList;
  final double devicePixelRatio;
  final Color panelBackgroundColor;
  final Color panelStickerBackgroundColor;
  final int panelStickerCrossAxisCount;
  final double panelStickerAspectRatio;
  final double stickerMaxScale;
  final double stickerMinScale;
  final bool stickerRotatable;
  final double stickerSize;
  final double panelHeight;
  late final Size viewport;
  final _StickItState _stickItState = _StickItState();

  Future<Uint8List> exportImage() async {
    await _stickItState._prepareExport();
    Future<Uint8List> exportImage = _stickItState._exportImage();
    return exportImage;
  }

  @override
  _StickItState createState() => _stickItState;
}

class _StickItState extends State<StickIt> {
  _StickItState();

  List<StickerImage> attachedList = [];
  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RepaintBoundary(
            key: key,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (widget.viewport == Size(0.0, 0.0))
                      widget.viewport = Size(constraints.maxWidth, constraints.maxHeight);
                    return widget.child;
                  },
                ),
                Stack(children: attachedList, fit: StackFit.expand)
              ],
            ),
          ),
        ),
        Scrollbar(
          child: DragTarget(
            builder: (BuildContext context, candidateData, List<dynamic> rejectedData) {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: this.widget.panelBackgroundColor,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.stickerList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: this.widget.panelStickerBackgroundColor,
                            child: TextButton(
                                onPressed: () {
                                  _attachSticker(widget.stickerList[i]);
                                },
                                child: widget.stickerList[i]),
                          ));
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: this.widget.panelStickerCrossAxisCount,
                        childAspectRatio: this.widget.panelStickerAspectRatio),
                  ),
                  height: this.widget.panelHeight);
            },
          ),
        ),
      ],
    );
  }

  void _attachSticker(Image image) {
    setState(() {
      attachedList.add(StickerImage(
        image,
        height: this.widget.stickerSize,
        key: Key("sticker_${attachedList.length}"),
        maxScale: this.widget.stickerMaxScale,
        minScale: this.widget.stickerMinScale,
        onTapRemove: (sticker) {
          this._onTapRemoveSticker(sticker);
        },
        rotatable: this.widget.stickerRotatable,
        viewport: this.widget.viewport,
        width: this.widget.stickerSize,
      ));
    });
  }

  Future<Uint8List> _exportImage() async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: this.widget.devicePixelRatio);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  void _onTapRemoveSticker(StickerImage sticker) {
    setState(() {
      this.attachedList.removeWhere((s) => s.key == sticker.key);
    });
  }

  Future<void> _prepareExport() async {
    attachedList.forEach((s) {
      s.prepareExport();
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
