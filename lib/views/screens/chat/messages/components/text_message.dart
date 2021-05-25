

import 'package:provider/provider.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock=Provider.of<UserBlock>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color:getMessageColor(message!.senderUid,userBlock.user!.uid),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message!.text!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: message!.isRemoved??true ? FontStyle.italic : FontStyle.normal,
          color: message!.senderUid!.isEmpty
              ? Colors.white
              :message!.isRemoved??true ? Colors.black54 : Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
