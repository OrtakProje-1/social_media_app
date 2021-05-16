import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/full_screen_video_player.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_delete_button.dart';
import 'package:video_player/video_player.dart';

class BuildVideoWidget extends StatefulWidget {
  const BuildVideoWidget({
    Key key,
    @required this.size,
    @required this.videos,
    @required this.onPressedDeleteButton,
  }) : super(key: key);

  final Size size;
  final ValueChanged<int> onPressedDeleteButton;
  final List<PlatformFile> videos;

  @override
  _BuildVideoWidgetState createState() => _BuildVideoWidgetState();
}

class _BuildVideoWidgetState extends State<BuildVideoWidget> {
  VideoPlayerController _controller;
  @override
  void initState() {
    print("videowidget initstate");
    super.initState();
    initialize();
  }

  void initialize(){
    if(widget.videos?.isNotEmpty)  _controller = VideoPlayerController.file(
      File(widget.videos[0]?.path),
    )..initialize().then((value) => setState(() {}));
  }

  @override
  void didUpdateWidget (BuildVideoWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    if(oldWidget.videos!=widget.videos){
    _controller.dispose();
    _controller=null;
    initialize();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    print("video widget build");
    return Container(
      height: 150,
      width: widget.size.width,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller?.value?.aspectRatio,
          child: Stack(
            children: [
              GestureDetector(
                child: VideoPlayer(_controller),
                onTap: (){
                  Navigate.pushPageDialog(context,FullScreenVideoPlayer(source: widget.videos[0].path,));
                },
              ),
              BuildDeleteButton(
            onPressed: ()=>widget.onPressedDeleteButton(0),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
