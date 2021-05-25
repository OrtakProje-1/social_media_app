import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/chat/messages/components/image_message.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key key,
    this.isSelected=false,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock=Provider.of<UserBlock>(context);
    bool isMee=message.senderUid==userBlock.user.uid;
    MyUser receiver=Provider.of<UsersBlock>(context).getUserFromUid(message.senderUid);
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message,key: PageStorageKey(message.audio.ref,));
        case ChatMessageType.video:
          return VideoMessage();
        case ChatMessageType.image:
          return ImageMessage(message: message);
        default:
          return SizedBox();
      }
    }

    return Container(
      color: isSelected ? Colors.grey.shade200.withOpacity(0.2) : Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding/2,vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMee ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMee) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage:CachedNetworkImageProvider(receiver.photoURL),
            ),
            SizedBox(width: kDefaultPadding / 2),
          ],
          Row(
            children: [
              if(isMee)...[
                Text(getTime(message.messageTime)),
                SizedBox(width: 5,)
              ],
              messageContaint(message),
              if(!isMee) ...[
                SizedBox(width: 5,),
                Text(getTime(message.messageTime)),
              ],
            ],
          ),
          if (isMee) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
  String getTime(int millis){
   DateTime time= DateTime.fromMillisecondsSinceEpoch(millis);
   return time.hour.toString()+":"+time.minute.toString();
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusDot({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1.color.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding/2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
