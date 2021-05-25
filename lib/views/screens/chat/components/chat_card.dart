

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/elapsed_time.dart';
import 'package:social_media_app/views/screens/chat/models/chat.dart';

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
    UserBlock userBlock=Provider.of<UserBlock>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical:12),
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
              color: Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:CachedNetworkImageProvider(chat.image!)
                      ),
                    ),
                  ),
                  if (true) // isActivate
                    Positioned(
                      right: -3,
                      bottom: 1,
                      child: Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3),
                        ),
                      ),
                    )
                ],
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
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          chat.senderUid==userBlock.user!.uid ? "Siz: ${chat.lastMessage}" :  chat.lastMessage!,
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
                child: Text(TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(chat.time!))),
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
