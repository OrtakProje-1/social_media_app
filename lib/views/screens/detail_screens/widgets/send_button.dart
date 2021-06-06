

import 'package:flutter/material.dart';
import 'package:social_media_app/util/const.dart';

class SendButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color? backgroundColor;
  final double size; 
  const SendButton({Key? key, this.onPressed,this.backgroundColor,this.size=46,this.iconColor=Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size, size),
        padding: EdgeInsets.all(0),
        primary:this.backgroundColor ?? recMesColor,
        elevation: 0,
        onPrimary: kPrimaryColor.withOpacity(0.3),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Icon(
          Icons.send_rounded,
          color:iconColor,
          size: 20,
        ),
      ),
    );
  }
}
