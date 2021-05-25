

import 'package:flutter/material.dart';

class BottomAppbarNotchedShape extends NotchedShape {
  final int space;
  final double radius;
  final double spaceRadius;
  final double horizontalSpace;
  BottomAppbarNotchedShape(
      {this.space = 5, this.radius = 20, this.spaceRadius = 8,this.horizontalSpace=0});
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    double iconSize=40;
    double guestLeft=host.width/2-iconSize;
    double guestRight=host.width/2+iconSize+1;
    double guestBottom=host.height/2+13;
    double guestCenter=host.width/2;
    Path path = Path()..lineTo(0, host.bottom)..lineTo(host.right, host.bottom);
    path.lineTo(host.right, radius);
    path.quadraticBezierTo(host.right, 0, host.right - radius, 0);
    path.lineTo(guestRight + space + spaceRadius+horizontalSpace, 0);
    path.quadraticBezierTo(
        guestRight + space+horizontalSpace, 0, guestRight + space - spaceRadius+horizontalSpace, spaceRadius);
    path
      ..lineTo(
          guestCenter + spaceRadius, guestBottom + space - spaceRadius);
    path.quadraticBezierTo(guestCenter, guestBottom + space,
        guestCenter - spaceRadius, guestBottom + space - spaceRadius);
    path.lineTo(guestLeft - space + spaceRadius-horizontalSpace, spaceRadius);
    path.quadraticBezierTo(
        guestLeft - space-horizontalSpace, 0, guestLeft - space - spaceRadius-horizontalSpace, 0);
    path.lineTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    // Path path = Path()..lineTo(0, host.bottom)..lineTo(host.right, host.bottom);
    // path.lineTo(host.right, radius);
    // path.quadraticBezierTo(host.right, 0, host.right - radius, 0);
    // path.lineTo(guest.right + space + spaceRadius, 0);
    // path.quadraticBezierTo(
    //     guest.right + space, 0, guest.right + space - spaceRadius, spaceRadius);
    // path
    //   ..lineTo(
    //       guest.center.dx + spaceRadius, guest.bottom + space - spaceRadius);
    // path.quadraticBezierTo(guest.center.dx, guest.bottom + space,
    //     guest.center.dx - spaceRadius, guest.bottom + space - spaceRadius);
    // path.lineTo(guest.left - space + spaceRadius, spaceRadius);
    // path.quadraticBezierTo(
    //     guest.left - space, 0, guest.left - space - spaceRadius, 0);
    // path.lineTo(radius, 0);
    // path.quadraticBezierTo(0, 0, 0, radius);
    return path;
  }
}