import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stick_it/src/sticker_image.dart';

/// [StickIt] creates a [Stack] view, consisting of
/// 1. the [child] provided as [Widget]
/// 2. a [List] of [Image]s called [stickerList].
///
/// The default behavior will allow the [Image]s to be added, scaled, rotated and deleted.
/// Sticker can be scaled within a customizable scale.
///
/// Calling the [exportImage] function will provide an [Uint8List],
/// that can be used to preview or further save the image + sticker composition.
///
/// See also:
///
///  * <https://github.com/myriky/flutter_simple_sticker_view>, which is the original project.
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

  /// Content you wish to place stickers upon.
  final Widget child;

  /// List of sticker images that should be shown within the bottom panel.
  /// Those can be placed on top of your child Widget.
  final List<Image> stickerList;

  /// The devices pixel ratio.
  /// See also: <https://stackoverflow.com/questions/8785643/what-exactly-is-device-pixel-ratio>
  final double devicePixelRatio;

  /// Background color of the bottom panel.
  final Color panelBackgroundColor;

  /// Height of the bottom panel.
  final double panelHeight;

  /// Background color of the container stickers are placed within.
  final Color panelStickerBackgroundColor;

  /// Defines how many stickers are placed within one row of the grid.
  final int panelStickerCrossAxisCount;

  /// Ratio of the cross-axis to the main-axis extent of each child.
  final double panelStickerAspectRatio;

  /// Maximal scaling ratio for your stickers.
  /// E.g 2 will allow the sticker to be twice as big!
  final double stickerMaxScale;

  /// Minimal scaling ratio for your stickers.
  /// E.g 0.5 will allow the sticker to be half as big at minimum!
  final double stickerMinScale;

  /// Controls whether your stickers should be rotatable, while the scaling event is active.
  /// Set to false, if you don't want rotation.
  final bool stickerRotatable;

  /// Size of the [Rect] the stickers are on when placed within the [Stack].
  ///
  /// Setting this value up will only increase the [Rect] size.
  /// So, to display them bigger when placing on the [child] you will have to set something like
  /// fit: Boxfit.cover on the image you are providing in the [stickerList].
  final double stickerSize;

  /// [Size] of the viewport that is provided.
  /// You don't have to set this manually, it will take the available space per default.
  final Size viewport;

  final _StickItState _stickItState = _StickItState();

  /// Creates an [Uint8List] out of your composition, that you can use to save as [Image].
  /// Before that it will clear all selections, so they don't appear on the new creation.
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

  final GlobalKey key = GlobalKey();
  List<StickerImage> _attachedList = [];
  late Size _viewport;

  @override
  void initState() {
    _viewport = widget.viewport;
    super.initState();
  }

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
                    if (_viewport == Size(0.0, 0.0)) _viewport = Size(constraints.maxWidth, constraints.maxHeight);
                    return widget.child;
                  },
                ),
                Stack(
                  children: _attachedList,
                  fit: StackFit.expand,
                )
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
      _attachedList.add(StickerImage(
        image,
        height: this.widget.stickerSize,
        key: Key("sticker_${_attachedList.length}"),
        maxScale: this.widget.stickerMaxScale,
        minScale: this.widget.stickerMinScale,
        onTapRemove: (sticker) {
          this._onTapRemoveSticker(sticker);
        },
        rotatable: this.widget.stickerRotatable,
        viewport: _viewport,
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
      this._attachedList.removeWhere((s) => s.key == sticker.key);
    });
  }

  Future<void> _prepareExport() async {
    _attachedList.forEach((s) {
      s.prepareExport();
    });
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
