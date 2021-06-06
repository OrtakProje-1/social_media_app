

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_media_app/views/widgets/blurWidget.dart';
import 'package:social_media_app/views/widgets/buttons/transparant_button.dart';

class BuildDeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const BuildDeleteButton({Key? key,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      right: 5,
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: BlurWidget(
          sigmaX: 1,
          sigmaY: 1,
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            child: Center(
              child: TransparantButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color:Colors.white,
                  size: 20,
                ),
                onPressed:onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
