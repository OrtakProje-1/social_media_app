

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/util/const.dart';
import 'package:vector_math/vector_math.dart' as vector;

typedef DisplayChange = void Function(bool isOpen);

class FabCircularMenu extends StatefulWidget {
  final List<Widget> children;
  final Alignment alignment;
  final Color? ringColor;
  final Color? ringSecondColor;
  final double? ringDiameter;
  final double? ringWidth;
  final double fabSize;
  final double fabElevation;
  final Color? fabColor;
  final EdgeInsets fabMargin;
  final Duration animationDuration;
  final Curve animationCurve;
  final DisplayChange? onDisplayChange;
  final AnimationController? animationController;

  FabCircularMenu(
      {Key? key,
      this.alignment = Alignment.bottomRight,
      this.ringColor,
      this.ringDiameter,
      this.ringWidth,
      this.fabSize = 64.0,
      this.fabElevation = 8.0,
      this.fabColor,
      this.fabMargin = const EdgeInsets.all(16.0),
      this.animationDuration = const Duration(milliseconds: 800),
      this.animationCurve = Curves.easeInOutCirc,
      this.onDisplayChange,
      this.ringSecondColor,
      this.animationController,
      required this.children})
      : assert(children.length >= 1),
        super(key: key);

  @override
  FabCircularMenuState createState() => FabCircularMenuState();
}

class FabCircularMenuState extends State<FabCircularMenu>
    with SingleTickerProviderStateMixin {
  late double _screenWidth;
  late double _screenHeight;
  late double _marginH;
  late double _marginV;
  late double _directionX;
  late double _directionY;
  late double _translationX;
  late double _translationY;

  Color? _ringColor;
  Color? _ringSecondColor;
  double? _ringDiameter;
  double? _ringWidth;

  late Animation<double> _scaleAnimation;
  late Animation _scaleCurve;
  late Animation _secondRingCurve;
  late Animation<double> _secondRingAnimation;

  bool _isOpen = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    widget.animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
        _isOpen = true;
        if (widget.onDisplayChange != null) {
          widget.onDisplayChange!(true);
        }
      } else if (status == AnimationStatus.dismissed) {
        _isAnimating = false;
        _isOpen = false;
        if (widget.onDisplayChange != null) {
          widget.onDisplayChange!(false);
        }
      }
    });

    _secondRingCurve = CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0.0, 0.8, curve: widget.animationCurve));
    _secondRingAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_secondRingCurve as Animation<double>)
          ..addListener(() {
            setState(() {});
          });


    _scaleCurve = CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0.0, 0.4, curve: widget.animationCurve));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_scaleCurve as Animation<double>)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    widget.animationController!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calcuProps();
  }

  @override
  Widget build(BuildContext context) {
    // This makes the widget able to correctly redraw on
    // hot reload while keeping performance in production
    if (!kReleaseMode) {
      _calcuProps();
    }

    return Container(
      margin: widget.fabMargin,
      // Removes the default FAB margin
      //transform: Matrix4.translationValues(16.0, 16.0, 0.0),
      child: Stack(
        alignment: widget.alignment,
        children: <Widget>[
          // Ring
          Transform(
            transform: Matrix4.translationValues(
              _translationX,
              _translationY,
              0.0,
            ),
            alignment: FractionalOffset.center,
            child: OverflowBox(
              maxWidth:widget.animationController!.value==0? 0 : _ringDiameter,
              maxHeight:widget.animationController!.value==0? 0 : _ringDiameter,
              child: Container(
                width: _ringDiameter,
                height: _ringDiameter,
                child: CustomPaint(
                  painter: _RingPainter(
                    width: _ringWidth,
                    color: _ringColor,
                    secondColor: _ringSecondColor,
                    secondValue: _secondRingAnimation.value,
                    value: widget.animationController!.value,
                  ),
                  child: _scaleAnimation.value == 1.0
                      ? Transform.rotate(
                          angle:(1 * pi * 2) - pi / 4,
                          child: Container(
                            child: Stack(
                              alignment: Alignment.center,
                              children: widget.children
                                  .asMap()
                                  .map((index, child) => MapEntry(index,
                                      _applyTransformations(child, index)))
                                  .values
                                  .toList(),
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ),

          // FAB
          Container(
            width: widget.fabSize,
            height: widget.fabSize,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: kPrimaryColor,
              shape:BeveledRectangleBorder(borderRadius: BorderRadius.circular(45)),
              elevation: widget.fabElevation,
              onPressed: () {
                if (_isAnimating) return;

                if (_isOpen) {
                  close();
                } else {
                  open();
                }
              },
              child: Center(
                child: Transform.rotate(
                  angle: widget.animationController!.value * ((pi / 4) * 7),
                  child: Icon(Icons.add_rounded,color: Colors.white.withOpacity(0.8),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applyTransformations(Widget child, int index) {
    double angleFix = 0.0;
    if (widget.alignment.x == 0) {
      angleFix = 67.5 * _directionY.abs();
    } else if (widget.alignment.y == 0) {
      angleFix = -67.5 * _directionX.abs();
    }

    final angle =
        vector.radians((135*widget.animationController!.value) / (widget.children.length - 1) * index + angleFix);

    return Transform(
        transform: Matrix4.translationValues(
            (-(_ringDiameter!/2) * cos(angle) +
                    (_ringWidth!/2 * cos(angle))) *
                _directionX,
            (-(_ringDiameter!/2) * sin(angle) +
                    (_ringWidth!/2 * sin(angle))) *
                _directionY,
            0),
        alignment: FractionalOffset.center,
        child: Opacity(
          opacity: widget.animationController!.value,
          child: Transform.rotate(
            angle: pi/4,
            child: Material(
              color: Colors.transparent,
              child: child,
            ),
          ),
        ));
  }
  /*

   Matrix4.translationValues(
            (-(_ringDiameter / 2) * cos(angle) +
                    (_ringWidth / 2 * cos(angle))) *
                _directionX,
            (-(_ringDiameter / 2) * sin(angle) +
                    (_ringWidth / 2 * sin(angle))) *
                _directionY,
            0.0)

  */

  void _calcuProps() {
    _ringColor = widget.ringColor ?? Theme.of(context).accentColor;
    _ringSecondColor = widget.ringSecondColor ?? kPrimaryColor;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _ringDiameter =
        widget.ringDiameter ?? min(_screenWidth, _screenHeight) * 1.25;
    _ringWidth = widget.ringWidth ?? _ringDiameter! * 0.3;
    _marginH = (widget.fabMargin.right + widget.fabMargin.left) / 2;
    _marginV = (widget.fabMargin.top + widget.fabMargin.bottom) / 2;
    _directionX = widget.alignment.x == 0 ? 1 : 1 * widget.alignment.x.sign;
    _directionY = widget.alignment.y == 0 ? 1 : 1 * widget.alignment.y.sign;
    _translationX =
        ((_screenWidth - widget.fabSize) / 2 - _marginH) * widget.alignment.x;
    _translationY =
        ((_screenHeight - widget.fabSize) / 2 - _marginV) * widget.alignment.y;
  }

  void open() {
    _isAnimating = true;
    widget.animationController!.forward().then((_) {
      _isAnimating = false;
      _isOpen = true;
      if (widget.onDisplayChange != null) {
        widget.onDisplayChange!(true);
      }
    });
  }

  void close() {
    _isAnimating = true;
    widget.animationController!.reverse().then((_) {
      _isAnimating = false;
      _isOpen = false;
      if (widget.onDisplayChange != null) {
        widget.onDisplayChange!(false);
      }
    });
  }

  bool get isOpen => _isOpen;
}

class _RingPainter extends CustomPainter {
  final double? width;
  final Color? color;
  final Color? secondColor;
  final double? value;
  final double? secondValue;

  _RingPainter({required this.width, this.color, this.value,this.secondValue,this.secondColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width < width! ? size.width : width!;
    final secondPaint = Paint()
      ..color = secondColor ?? Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width < width! ? size.width : width!;

    canvas.drawArc(
        Rect.fromLTWH(
            width! / 2-1, width! / 2-1, size.width - width!+2, size.height - width!+3),
        pi,
        pi * secondValue!,
        false,
        secondPaint);
    canvas.drawArc(
        Rect.fromLTWH(
            width! / 2, width! / 2, size.width - width!, size.height - width!),
        pi,
        pi * value!,
        false,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
