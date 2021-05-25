

import 'package:flutter/material.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';

class BuildUserListile extends StatelessWidget {
  final MyUser? user;
  final VoidCallback? onPressed;
  final Icon? icon;
  final String? mesaj;
  final Color? textColor;
  final Color? buttonBackgroundColor;
  const BuildUserListile({Key? key,this.user,this.onPressed,this.icon,this.mesaj,this.textColor,this.buttonBackgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color txtColor = textColor ?? Colors.red.shade300;
    Color btnColor = buttonBackgroundColor ?? Colors.grey.shade300;
    return ListTile(
      title: Text(user!.displayName!),
      leading: BuildUserImageAndIsOnlineWidget.fromUser(
        user: user,
      ),
      subtitle: Text(user!.email!),
      trailing: TextButton.icon(
        onPressed:onPressed,
        style: TextButton.styleFrom(
            backgroundColor: btnColor,
            primary: Colors.red.shade300),
        icon: icon!,
        label: Text(
          mesaj!,
          style: TextStyle(color:txtColor),
        ),
      ),
      onTap: (){
        Navigate.pushPage(context,ProfileScreen(user: user));
      },
    );
  }
}
