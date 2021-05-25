

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_viewer/domain/bloc/controller.dart';
import 'package:video_viewer/video_viewer.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String? source;
  final bool isFile;
  FullScreenVideoPlayer({Key? key, this.isFile = true, this.source})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  VideoViewerController _controller = VideoViewerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: VideoViewer(
          autoPlay: true,
          controller: _controller,
          language: VideoViewerLanguage(quality: "Video Kalitesi",speed: "Video Hızı",seconds: "Saniye",settings: "Ayarlar",caption: "Video",captionNone: "Video Yok",normalSpeed: "Normal Hız"),
          source: {
            "video": VideoSource(
              video: widget.isFile
                  ? VideoPlayerController.file(File(widget.source!))
                  : VideoPlayerController.network(widget.source!),
            ),
          },
          looping: true,
    ),
        ),
      ),
    );
  }
}
