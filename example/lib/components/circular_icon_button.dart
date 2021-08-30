import 'package:flutter/material.dart';

/// A reusable [CircularIconButton] that creates a circular button with an icon within.
///
/// Requires an [_iconWidget] of type Icon, so you can manually handle what to display within the button.
/// The button can be configured with [_boxHeight], [_boxWidth], [_boxElevation], [_boxColor].
/// Can also optionally fire an action onTap if you pass [_onTap]. o/
class CircularIconButton extends StatelessWidget {
  final double _boxElevation;
  final double _boxHeight;
  final double _boxWidth;
  final Color _boxColor;
  final Icon _iconWidget;
  final void Function()? _onTap;

  const CircularIconButton({
    Key? key,
    required iconWidget,
    boxElevation,
    boxHeight,
    boxWidth,
    boxColor,
    onTap,
  })  : this._iconWidget = iconWidget,
        this._boxColor = boxColor ?? Colors.black,
        this._boxElevation = boxElevation ?? 8,
        this._boxHeight = boxHeight ?? 56,
        this._boxWidth = boxWidth ?? 56,
        this._onTap = onTap ?? null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: _boxColor,
        elevation: _boxElevation,
        child: InkWell(
          child: SizedBox(
              width: _boxWidth, height: _boxHeight, child: _iconWidget),
          onTap: _onTap,
        ),
      ),
    );
  }
}
