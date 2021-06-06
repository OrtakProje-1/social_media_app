

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/elapsed_time.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';

class ExtendedImageView extends StatelessWidget {
  final ChatMessage? message;
  const ExtendedImageView({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: getAppBarTitle(message!, userBlock, usersBlock),
      ),
      body: ExtendedImageGesturePageView(
        scrollDirection: Axis.horizontal,
        children: message!.images!
            .map((e) => ExtendedImage.network(
                  e!.downloadURL!,
                  mode: ExtendedImageMode.gesture,
                ))
            .toList(),
      ),
    );
  }

  Widget getAppBarTitle(ChatMessage m, UserBlock block, UsersBlock usersBlock) {
    Widget widget = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Siz"),
        Text(
          TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(m.messageTime!)),
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ],
    );
    if (m.sender!.uid == block.user!.uid) {
      return widget;
    } else {
      widget = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      usersBlock.getUserFromUid(m.sender!.uid)!.photoURL!),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          widget
        ],
      );
      return widget;
    }
  }
}
