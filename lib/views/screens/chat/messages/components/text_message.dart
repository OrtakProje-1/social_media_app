import 'package:provider/provider.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage(
      {Key? key, this.message, this.nextMessage, this.prevMessage})
      : super(key: key);

  final ChatMessage? message;
  final ChatMessage? prevMessage;
  final ChatMessage? nextMessage;

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    CryptoBlock cryptoBlock = CryptoBlock();
    String myUid = userBlock.user!.uid;
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.5,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: getMessageColor(message!.sender!.uid, userBlock.user!.uid),
        borderRadius: getBorderRadius(myUid),
      ),
      child: Text(
        cryptoBlock.decrypt(userBlock.user!.uid == message!.sender!.uid
            ? message!.senderCryptedText!
            : message!.recCryptedText!),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle:
              message!.isRemoved ?? true ? FontStyle.italic : FontStyle.normal,
          color: message!.sender!.uid!.isEmpty
              ? Colors.white
              : message!.isRemoved ?? true
                  ? Colors.black54
                  : Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }

  BorderRadius getBorderRadius(String uid) {
    if (message!.sender!.uid == uid) {
      bool next = false;
      bool prev = false;
      if (nextMessage != null) {
        next = nextMessage!.sender!.uid == uid;
      }
      if (prevMessage != null) {
        prev = prevMessage!.sender!.uid == uid;
      }
      return BorderRadius.only(
          topRight: Radius.circular(!next ? 22 : 0),
          bottomRight: Radius.circular(!prev ? 22 : 0),
          bottomLeft: Radius.circular(22),
          topLeft: Radius.circular(22));
    } else {
      bool next = false;
      bool prev = false;
      if (nextMessage != null) {
        next = nextMessage!.receiver!.rUid == uid;
      }
      if (prevMessage != null) {
        prev = prevMessage!.receiver!.rUid == uid;
      }
      return BorderRadius.only(
          bottomLeft: Radius.circular(!prev ? 22 : 0),
          topLeft: Radius.circular(!next ? 22 : 0),
          bottomRight: Radius.circular(22),
          topRight: Radius.circular(22));
    }
  }
}
