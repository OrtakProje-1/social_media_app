

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/crypto_block.dart';
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
    CryptoBlock cryptoBlock=CryptoBlock();
    String mesaj=cryptoBlock.decrypt(userBlock.user!.uid == message!.sender!.uid
            ? message!.senderCryptedText!
            : message!.recCryptedText!);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: getAppBarTitle(message!, userBlock, usersBlock),
      ),
      body: Stack(
        children: [
          ExtendedImageGesturePageView(
            scrollDirection: Axis.horizontal,
            children: message!.images!
                .map((e) => ExtendedImage.network(
                      e!.downloadURL!,
                      mode: ExtendedImageMode.gesture,
                    ))
                .toList(),
          ),
        if(mesaj.isNotEmpty)  Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.black38,
              child: Text(mesaj,style: TextStyle(fontSize:17),),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarTitle(ChatMessage m, UserBlock block, UsersBlock usersBlock) {
    Widget widget = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(m.sender!.uid == block.user!.uid?"Siz":m.sender!.name!),
        Text(
          TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(m.messageTime!)),
          style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),
        ),
      ],
    );
    if (m.sender!.uid == block.user!.uid) {
      return widget;
    } else {
      widget = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
