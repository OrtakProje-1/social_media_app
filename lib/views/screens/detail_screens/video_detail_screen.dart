import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/loading_mixin.dart';
import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/enum.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/chat/models/sender_media_message.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/send_button.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/textfield_widget.dart';
import 'package:social_media_app/views/screens/full_screen_video_player.dart';
import 'package:social_media_app/views/widgets/build_rec_appbar_title.dart';

class VideoDetailScreen extends StatefulWidget {
  final PlatformFile? video;
  final MyUser? receiver;
  VideoDetailScreen({Key? key, this.video,this.receiver}) : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> with LoadingMixin{
  bool playing = false;
  TextEditingController _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StorageBlock storageBlock=Provider.of<StorageBlock>(context);
    UserBlock userBlock=Provider.of<UserBlock>(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        titleSpacing: 0,
        title:BuildReceiverAppBarTitle(
          user: widget.receiver,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 70,
            child: FullScreenVideoPlayer(
              isFile: true,
              source: widget.video!.path,
              listener: listener,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: 0,
            right: 0,
            bottom: playing ? 00 : 0,
            child: Container(
              width: double.maxFinite,
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      controller: _message,
                    ),
                  ),
                  SendButton(
                    backgroundColor: Colors.white,
                    onPressed: () async{
                      showLoadingDialog(context,"Video");
                      MediaReference vidRef= await storageBlock.uploadVideo(file:File(widget.video!.path!), userUid:userBlock.user!.uid);
                      Navigator.pop(context);
                      SenderMediaMessage videoMessage=SenderMediaMessage(
                        message: _message.text,
                        type: ChatMessageType.video,
                        refs: [vidRef]
                      );
                      Navigator.pop(context,videoMessage);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void listener(bool isPlaying) {
    print("listener");
    if (isPlaying != playing) {
      setState(() {
        playing = isPlaying;
      });
    }
  }
}
