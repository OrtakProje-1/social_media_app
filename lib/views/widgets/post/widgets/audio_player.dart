import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_media_app/util/const.dart';

class AudioPlayerPost extends StatefulWidget {
  final String? audio;
  final Size? size;
  AudioPlayerPost({Key? key, this.audio, this.size}) : super(key: key);

  @override
  _AudioPlayerPost createState() => _AudioPlayerPost();
}

class _AudioPlayerPost extends State<AudioPlayerPost> {
  AudioPlayer? _player;
  double millisecond = 0;
  bool sliderScroll = false;
  double scrollSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    loadData();
  }

  void loadData() async {
    print("load data");
    if (widget.audio != null) {
      Duration? dur = await _player!.setUrl(widget.audio!);
      setState(() {
        millisecond = dur!.inMilliseconds.toDouble();
      });
    }
  }

  @override
  void dispose() {
    print("dispose");
    _player?.dispose();
    _player = null;
    super.dispose();
  }

  bool get isPlaying {
    if (_player != null) {
      return _player!.playerState.playing;
    } else
      return false;
  }

  @override
  void didUpdateWidget(AudioPlayerPost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audio != oldWidget.audio && widget.audio != null) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: widget.size?.width ?? 250,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: widget.audio == null
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildButton(
                  onPressed: () {
                    if (_player != null) {
                      if (isPlaying) {
                        _player!.pause();
                      } else {
                        _player!.play();
                      }
                    }
                    setState(() {});
                  },
                  icon: isPlaying
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: StreamBuilder<Duration>(
                        stream: _player!.bufferedPositionStream,
                        initialData: Duration.zero,
                        builder: (context, buffer) {
                          return Center(
                            child: StreamBuilder<Duration>(
                                stream: _player!.positionStream,
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 16),
                                            thumbShape: RoundSliderThumbShape(
                                                disabledThumbRadius: 10,
                                                enabledThumbRadius: 8),
                                          ),
                                          child: Slider(
                                            min: 0,
                                            max: millisecond,
                                            value: sliderScroll
                                                ? scrollSliderValue
                                                : snapshot.hasData
                                                    ? (snapshot.data!
                                                                .inMilliseconds
                                                                .toDouble() >=
                                                            millisecond
                                                        ? millisecond
                                                        : snapshot.data!
                                                            .inMilliseconds
                                                            .toDouble())
                                                    : 0,
                                            activeColor: kPrimaryColor,
                                            inactiveColor: kPrimaryColor
                                                .withOpacity(0.2),
                                            onChanged: (i) {
                                              setState(() {
                                                scrollSliderValue = i;
                                              });
                                            },
                                            onChangeStart: (d) {
                                              setState(() {
                                                sliderScroll = true;
                                              });
                                            },
                                            onChangeEnd: (e) async {
                                              setState(() {
                                                sliderScroll = false;
                                              });
                                              print(Duration(
                                                      milliseconds:
                                                          e.toInt())
                                                  .toString());
                                              await _player!.seek(Duration(
                                                  milliseconds: e.toInt()));
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      if (_player!.duration != null)
                                        StreamBuilder<Duration>(
                                            stream: _player!.positionStream,
                                            initialData: Duration.zero,
                                            builder: (context, snapshot) {
                                              return Text(sliderScroll
                                                  ? getDuration(Duration(
                                                      milliseconds:
                                                          scrollSliderValue
                                                              .toInt()))
                                                  : getDuration(
                                                      _player!.duration!));
                                            }),
                                    ],
                                  );
                                }),
                          );
                        }),
                  ),
                ),
              ],
            ),
    );
  }

  String getDuration(Duration dur) {
    int min = dur.inMinutes;
    String minS = min < 10 ? "0$min" : min.toString();
    int sec = dur.inSeconds % 60;
    String secS = sec < 10 ? "0$sec" : sec.toString();
    return minS + ":" + secS;
  }

  Container buildButton({VoidCallback? onPressed, IconData? icon}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          splashRadius: 20,
          splashColor: kPrimaryColor.withOpacity(0.5),
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
