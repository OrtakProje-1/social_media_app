import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  const BlurWidget({Key key, this.child,this.sigmaX=10,this.sigmaY=10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      child: child,
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    );
  }
}