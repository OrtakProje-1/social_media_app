import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/crypto_block.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/data.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/detail_screens/video_detail_screen.dart';
import 'package:social_media_app/views/screens/detail_screens/video_preview.dart';
import 'package:social_media_app/views/screens/full_screen_video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoMessage extends StatefulWidget {
  final ChatMessage? message;
  VideoMessage({Key? key, required this.message}) : super(key: key);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  Uint8List? videoThump;

  @override
  void initState() {
    super.initState();
    getThump();
  }

  getThump() async {
    videoThump = await VideoThumbnail.thumbnailData(
      video: widget.message!.video!.downloadURL!,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
      timeMs: 0,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    CryptoBlock cryptoBlock=CryptoBlock();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60, // 60% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                getMessageColor(widget.message!.sender!.uid, userBlock.user!.uid),
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigate.pushPage(context,VideoPreview(
                      message: widget.message!,
                      sender: usersBlock.getUserFromUid(widget.message!.sender!.uid),
                    ));
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        top: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                            bottom: Radius.circular(
                                widget.message!.recCryptedText!.isNotEmpty ? 0 : 8),
                          ),
                          child: videoThump == null
                              ? SizedBox(width: 10,height: 10,)
                              : Image.memory(videoThump!,fit: BoxFit.cover,),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.message!.recCryptedText!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      width: double.maxFinite,
                      child: Text(
                         cryptoBlock.getPrivateKey().decrypt(userBlock.user!.uid==widget.message!.sender!.uid ? widget.message!.senderCryptedText! : widget.message!.recCryptedText!),
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
