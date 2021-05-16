import 'package:flutter/material.dart';

class TransparantButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final double iconSize;
  TransparantButton({Key key, this.icon, this.onPressed,this.iconSize=24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      hoverColor: Colors.transparent,
      color: Colors.transparent,
      disabledColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: icon,
      onPressed: onPressed,
    );
  }
}
