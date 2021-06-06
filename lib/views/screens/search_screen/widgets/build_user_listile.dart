

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/usersBlock.dart';
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
  final Color? primary;
  final OutlinedBorder? shape;
  const BuildUserListile({Key? key,this.shape,this.primary,this.user,this.onPressed,this.icon,this.mesaj,this.textColor,this.buttonBackgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color btnColor = buttonBackgroundColor ?? Colors.grey.shade300;
    UsersBlock usersBlock=Provider.of<UsersBlock>(context);
    return ListTile(
      title: Text(user!.displayName!),
      leading: BuildUserImageAndIsOnlineWidget(
        uid: user!.uid,
        usersBlock: usersBlock,
      ),
      trailing: TextButton.icon(
        onPressed:onPressed,
        style: TextButton.styleFrom(
           // backgroundColor: btnColor,
           shape: shape,
            primary: primary),
        icon: icon!,
        label: Text(
          mesaj!,
          style: TextStyle(color:textColor,fontWeight: FontWeight.bold),
        ),
      ),
      onTap: (){
        Navigate.pushPage(context,ProfileScreen(user: user));
      },
    );
  }
}
