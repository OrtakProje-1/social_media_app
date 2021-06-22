import 'dart:math';

import 'package:flutter/material.dart';

class BorderAnimation extends StatefulWidget {

  final Duration? duration;
  final Color? disableBorderColor;
  final Color? enableBorderColor;

  BorderAnimation({Key? key,this.disableBorderColor,this.duration,this.enableBorderColor}) : super(key: key);

  @override
  _BorderAnimationState createState() => _BorderAnimationState();
}

class _BorderAnimationState extends State<BorderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool border = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 2000), vsync: this)
          ..addListener(() {
            setState(() {
            });
          });
  }

  void changeAnimation(){
    if(_controller.status==AnimationStatus.completed||_controller.status==AnimationStatus.forward){
      _controller.reverse();
    }else if(_controller.status==AnimationStatus.dismissed||_controller.status==AnimationStatus.reverse){
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(
        title: Text("Border"),
      ),
      body: Center(
        child: Container(
          width: 220,
          height: 220,
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 202,
                  height: 202,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                bottom: 8,
                left: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ClipPath(
                    clipper: BorderClip(_controller.value),
                    child: Container(
                      width: 204,
                      height: 204,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    changeAnimation();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BorderClip extends CustomClipper<Path> {
  double value;
  BorderClip(this.value);
  @override
  Path getClip(Size size) {
    double x = size.width;
    double y = size.height;
    Path path = new Path();
    path.moveTo(x, 0);
      print(value);
    if (value <= 0.5) {
      path.lineTo(x - (x * (value / 0.5)), 0);
      path.lineTo(x, y * (value / 0.5));
    } else {
      path.lineTo(0, 0);
      path.lineTo(0, y * ((value / 0.5)-1));
      path.lineTo(x - (x * ((value / 0.5)-1)), y);
      path.lineTo(x, y);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
