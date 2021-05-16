import 'package:flutter/material.dart';
import 'package:social_media_app/views/widgets/blurWidget.dart';
import 'package:social_media_app/views/widgets/buttons/transparant_button.dart';

class BlurButton extends StatelessWidget {
  final Icon icon;
  final double sigma;
  final VoidCallback onPressed;
  final Color buttonBackgroundColor;
  final double iconSize;
  const BlurButton({Key key,this.icon,this.sigma=5,this.onPressed,this.buttonBackgroundColor,this.iconSize=24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: BlurWidget(
          sigmaX:sigma,
          sigmaY: sigma,
          child: Container(
            decoration: BoxDecoration(color:buttonBackgroundColor),
            child: Center(
              child: TransparantButton(
                icon:icon,
                iconSize: iconSize,
                onPressed:onPressed,
              ),
            ),
          ),
        ),
      );
  }
}