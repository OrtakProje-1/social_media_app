import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_viewer/video_viewer.dart';
import 'package:chewie/chewie.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String? source;
  final bool isFile;
  final ValueChanged<bool>? listener;
  FullScreenVideoPlayer(
      {Key? key, this.isFile = true, this.source, this.listener})
      : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  @override
  void dispose() { 
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  initializeVideo() async {
    _videoPlayerController =widget.isFile ? VideoPlayerController.file(File(widget.source!)) : VideoPlayerController.network(widget.source!);
    await _videoPlayerController?.initialize();
    _videoPlayerController?.addListener(() {
      if (widget.listener != null) {
        widget.listener!(_videoPlayerController!.value.isPlaying);
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      looping: true,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      allowFullScreen: true,
      systemOverlaysAfterFullScreen:SystemUiOverlay.values,
      systemOverlaysOnEnterFullScreen: SystemUiOverlay.values,
      allowPlaybackSpeedChanging: false,
      autoInitialize: true,
      fullScreenByDefault: false,
      showControlsOnInitialize: false,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
        ),
      ),
    );
  }
}
