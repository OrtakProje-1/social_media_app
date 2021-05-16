import 'package:flutter/material.dart';

class ModalSheetClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}