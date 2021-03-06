import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/elapsed_time.dart';
import 'package:social_media_app/views/screens/chat/models/chat.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    CryptoBlock cryptoBlock=CryptoBlock();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: press,
        highlightColor: kPrimaryColor.withOpacity(0.1),
        splashColor: kPrimaryColor.withOpacity(0.2),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade500.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              BuildUserImageAndIsOnlineWidget(
                usersBlock: usersBlock,
                uid: chat.senderUid==userBlock.user!.uid ? chat.rUid : chat.senderUid,
                width: 45,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          chat.senderUid == userBlock.user!.uid
                              ? "Siz: ${cryptoBlock.decrypt(chat.lastMessage!)}"
                              : cryptoBlock.decrypt(chat.lastMessage!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*  chat.unReadCount==0 ? */
              Opacity(
                opacity: 0.64,
                child: Text(TimeElapsed.fromDateTime(
                    DateTime.fromMillisecondsSinceEpoch(chat.time!))),
              ),
              // :Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //      Opacity(
              //   opacity: 0.64,
              //   child: Text(chat.time.toString()),
              // ),
              // SizedBox(height: 2,),
              // Container(
              //   constraints: BoxConstraints(minWidth:20),
              //   padding: EdgeInsets.all(2),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(4),
              //     color: kPrimaryColor.withOpacity(0.5)
              //   ),
              //   child: Center(child: Text(chat.unReadCount.toString(),style: TextStyle(color: Colors.black54),),),
              // ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
