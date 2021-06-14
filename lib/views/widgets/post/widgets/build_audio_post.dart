import 'package:flutter/material.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_audio_widget.dart';
import 'package:social_media_app/views/widgets/post/widgets/audio_player.dart';

class BuildAudioPost extends StatefulWidget {
  final Post post;
  BuildAudioPost({Key? key,required this.post}) : super(key: key);

  @override
  _BuildAudioPostState createState() => _BuildAudioPostState();
}

class _BuildAudioPostState extends State<BuildAudioPost> {
  @override
  Widget build(BuildContext context) {
    return AudioPlayerPost(
      audio: widget.post.audio!.downloadURL,
      size: MediaQuery.of(context).size,
    );
  }
}