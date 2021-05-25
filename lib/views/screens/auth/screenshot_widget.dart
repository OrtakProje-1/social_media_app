import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotWidget extends StatefulWidget {
  final String url;
  final Widget child;
  final double size;
  final ScreenshotController controller;
  ScreenshotWidget.fromWidget({Key key,this.child,this.size=150,this.controller}): this.url=null,super(key: key);
  ScreenshotWidget({Key key, this.url,this.size=150,this.controller}) : this.child=null,super(key: key);

  @override
  _ScreenshotWidgetState createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.primaries[2],
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 1,
            color: Colors.grey.shade300
          ),
        ],
      ),
      width:widget.size,
      height: widget.size,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(4),
      child:widget.child!=null ? widget.child : ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Screenshot(
            controller: widget.controller,
            child: SvgPicture.network(widget.url)),
      ),
    );
  }
}

class ImagePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Offset center=Offset(size.width/2,size.height/2);
    canvas.drawCircle(center,size.width/2,Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

}
