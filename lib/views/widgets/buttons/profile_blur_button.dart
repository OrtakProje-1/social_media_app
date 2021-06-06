

import 'package:flutter/material.dart';
import 'package:social_media_app/views/widgets/blurWidget.dart';
import 'package:social_media_app/views/widgets/buttons/transparant_button.dart';

class ProfileBlurButton extends StatelessWidget {
  final Icon? icon;
  final VoidCallback? onPressed;
  ProfileBlurButton({Key? key, this.icon, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BlurWidget(
          sigmaX: 5,
          sigmaY: 5,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Center(
              child: TransparantButton(
                icon: icon,
                onPressed:onPressed
              ),
            ),
          ),
        ),
      ),
    );
  }
}
