

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class CustomProgressButton extends StatelessWidget {
  final ButtonState? state;
  final VoidCallback? onPressed;
  final String loadingText;
  final String successText;
  final String errorText;
  final String idleText;
  final double? value;
  const CustomProgressButton({
    Key? key,
    this.state,
    this.onPressed,
    this.errorText="Hata Oluştu",
    this.idleText="Paylaş",
    this.loadingText="Post Göderiliyor",
    this.successText="Post Gönderildi",
    this.value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var progressTextButton = ProgressButton.icon(
      height: 45.0,
      radius: 12.0,
      progressIndicator:CircularProgressIndicator(
            value:value,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      iconedButtons: {
        ButtonState.idle: IconedButton(
          text:idleText,
          color: Colors.blueGrey.shade400,
          icon: Icon(
            Icons.send_rounded,
            color: Colors.white,
          ),
        ),
        ButtonState.loading: IconedButton(
          text:loadingText,
          color: Colors.blueGrey.shade400,
          icon: Icon(Icons.send_rounded),
        ),
        ButtonState.fail: IconedButton(
          text:errorText,
          color: Colors.red,
          icon: Icon(
            Icons.cancel_schedule_send_rounded,
            color: Colors.white,
          ),
        ),
        ButtonState.success: IconedButton(
          text:successText,
          color: Colors.green,
          icon: Icon(
            Icons.check_rounded,
            color: Colors.white,
          ),
        ),
      },
      onPressed: onPressed,
      state: state,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }
}
