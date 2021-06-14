import 'package:flutter/material.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/views/widgets/post/widgets/video_player.dart';

class BuildVideoPost extends StatefulWidget {
  final Post post;
  BuildVideoPost({Key? key,required this.post}) : super(key: key);

  @override
  _BuildVideoPostState createState() => _BuildVideoPostState();
}

class _BuildVideoPostState extends State<BuildVideoPost> {
  @override
  Widget build(BuildContext context) {
    print("video");
    return AspectRatio(
      aspectRatio: 10/6,
      child:VideoPlayer(isFile: false,source: widget.post.video!.downloadURL,),
    );
  }
}