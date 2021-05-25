

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IsOnlinePainter extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path=Path();
    path.moveTo(0,0);
    path.lineTo(size.width/2-10,size.height);
    path.lineTo(size.width/2+10,size.height);
    path.lineTo(size.width,0);
    path.lineTo(0,0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper)=>true;
 
}