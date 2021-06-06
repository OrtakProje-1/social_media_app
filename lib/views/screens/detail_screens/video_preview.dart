import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/data.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/full_screen_video_player.dart';
import 'package:social_media_app/views/widgets/build_rec_appbar_title.dart';

class VideoPreview extends StatefulWidget {
  final MyUser? sender;
  final ChatMessage? message;
  VideoPreview({Key? key,this.message,this.sender}) : super(key: key);

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock=Provider.of<UserBlock>(context);
    bool isMee=widget.message!.sender!.uid==userBlock.user!.uid;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:Container(
        child: Row(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.sender!.photoURL!),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap:null,
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(4),
                height: AppBar().preferredSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMee ? "Siz" : widget.sender!.displayName!,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(widget.message!.messageTime!).toString(),
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
      body: FullScreenVideoPlayer(
        isFile: false,
        source: widget.message!.video!.downloadURL!,
      ),
    );
  }
}