import 'package:flutter/material.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';


class AudioMessage extends StatelessWidget {
  final ChatMessage message;

  const AudioMessage({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withOpacity(message.senderUid.isEmpty ? 1 : 0.1),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(90),
            onTap: (){},
            child: Icon(
              Icons.play_arrow,
              color: message.senderUid.isEmpty ? Colors.white : kPrimaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: kDefaultPadding/1.5),
              child: SliderTheme(
                data: SliderThemeData(
                  overlayShape: RoundSliderOverlayShape(overlayRadius:0),
                  thumbShape: RoundSliderThumbShape(disabledThumbRadius:12,enabledThumbRadius:7,),
                ),
                child: Slider(
                  value: 0,
                  max: 100,
                  min: 0,
                  activeColor: kPrimaryColor,
                  inactiveColor: kPrimaryColor.withOpacity(0.3),
                  onChanged:(i){},
                ),
              ),
            ),
          ),
          Text(
            "0.37",
            style: TextStyle(
                fontSize: 12, color: message.senderUid.isEmpty ? Colors.white : null),
          ),
        ],
      ),
    );
  }
}
