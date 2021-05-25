import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BuildAudioWidget extends StatefulWidget {
  final List<PlatformFile> audios;
  final Size size;
  final ValueChanged<int> onPressedDeleteButton;
  BuildAudioWidget(
      {Key key, this.audios, this.size, this.onPressedDeleteButton})
      : super(key: key);

  @override
  _BuildAudioWidgetState createState() => _BuildAudioWidgetState();
}

class _BuildAudioWidgetState extends State<BuildAudioWidget> {
  AudioPlayer _player;
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
    if (widget.audios?.isNotEmpty) {
      Duration dur = await _player.setFilePath(widget.audios[0]?.path);
      setState(() {
        millisecond = dur.inMilliseconds.toDouble();
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
      return _player.playerState.playing;
    } else
      return false;
  }

  @override
  void didUpdateWidget(BuildAudioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audios != oldWidget.audios && widget.audios?.isNotEmpty) {
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
      child: widget.audios?.isEmpty
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildButton(
                  onPressed: () {
                    if (_player != null) {
                      if (isPlaying) {
                        _player.pause();
                      } else {
                        _player.play();
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
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text(
                          widget.audios[0]?.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        StreamBuilder<Duration>(
                            stream: _player.positionStream,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  if (widget.onPressedDeleteButton != null)
                                    Text(_player.position?.inMinutes
                                            ?.toString() +
                                        ":" +
                                        (_player.position?.inSeconds % 60)
                                            .toString()),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        overlayShape: RoundSliderOverlayShape(
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
                                                ? (snapshot.data?.inMilliseconds
                                                            ?.toDouble() >=
                                                        millisecond
                                                    ? millisecond
                                                    : snapshot
                                                        ?.data?.inMilliseconds
                                                        ?.toDouble())
                                                : 0,
                                        activeColor: Colors.red.shade300,
                                        inactiveColor:
                                            Colors.black.withOpacity(0.1),
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
                                          print(
                                              Duration(milliseconds: e.toInt())
                                                  .toString());
                                          await _player.seek(Duration(
                                              milliseconds: e.toInt()));
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  if (_player.duration != null)
                                    StreamBuilder<Duration>(
                                        stream: _player.positionStream,
                                        initialData: Duration.zero,
                                        builder: (context, snapshot) {
                                          return Text(sliderScroll
                                              ? getDuration(Duration(
                                                  milliseconds:
                                                      scrollSliderValue
                                                          .toInt()))
                                              : getDuration(snapshot.data));
                                        }),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                if (widget.onPressedDeleteButton != null)
                  buildButton(
                      icon: Icons.delete_outline_rounded,
                      onPressed: () => widget.onPressedDeleteButton(0)),
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

  Container buildButton({VoidCallback onPressed, IconData icon}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          splashRadius: 20,
          splashColor: Colors.red.shade300.withOpacity(0.5),
          icon: Icon(
            icon,
            color: Colors.red.shade300,
          ),
        ),
      ),
    );
  }
}
