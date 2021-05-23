import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/extended_image_view.dart';

class ImageMessage extends StatelessWidget {
  final ChatMessage message;
  const ImageMessage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60, // 55% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: getMessageColor(message.senderUid, userBlock.user.uid),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 2,
                        right: 2,
                        left: 2,
                        bottom: message.text.isNotEmpty ? 0 : 2),
                    child: InkWell(
                      child: getImageWidget(message, userBlock.user.uid),
                      onTap: () {
                        Navigate.pushPage(
                            context, ExtendedImageView(message: message));
                      },
                    ),
                  ),
                ),
                if (message.text != null)
                  if (message.text.isNotEmpty)
                    Container(
                        padding: EdgeInsets.all(5),
                        width: double.maxFinite,
                        child: Text(
                          message.text,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold,color:getMessageTextColor(message.senderUid, userBlock.user.uid )),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getImageWidget(ChatMessage message, String myUid) {
    bool noText = message.text == null ? true : message.text.isEmpty;
    switch (message.images.length) {
      case 1:
        return buildImageWidget(message.images[0], tL: 8, tR: 8, bL: noText ? 8 : 0, bR: noText ? 8 : 0);
      case 2:
        return Row(
          children: [
            buildImageWidget(message.images[0], tL: 8, bL: noText ? 8 : 0),
            verticalDivider(),
            buildImageWidget(message.images[1], tR: 8, bR: noText ? 8 : 0),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  buildImageWidget(message.images[0], tL:8),
                  horizontalDivider(),
                  buildImageWidget(message.images[1], bL: noText ? 8 : 0),
                ],
              ),
            ),
            verticalDivider(),
            buildImageWidget(message.images[2], tR: 8, bR: noText ? 8 : 0),
          ],
        );
      default:
      int overCount=message.images.length-4;
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                     buildImageWidget(message.images[0], tL: 8),
                     verticalDivider(),
                     buildImageWidget(message.images[1], tR: 8),
                    ],
                  ),
                ),
                horizontalDivider(),
                Expanded(
                  child: Row(
                    children: [
                      buildImageWidget(message.images[2], bL: noText ? 8 : 0),
                      verticalDivider(),
                      buildImageWidget(message.images[3], bR: noText ? 8 : 0),
                    ],
                  ),
                ),
              ],
            ),
          if(message.images.length>4)  Center(
            child: Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: getMessageColor(message.senderUid,myUid)
              ),
              child: Center(
                child: Text("+${overCount>9 ? 9 : overCount}",style: TextStyle(color: getMessageTextColor(message.senderUid,myUid),fontWeight: FontWeight.bold),),
              ),
            ),
          ),
          ],
        );
    }
  }

  Expanded buildImageWidget(String url,
      {double tR = 0, double tL = 0, double bR = 0, double bL = 0}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bL),
            bottomRight: Radius.circular(bR),
            topLeft: Radius.circular(tL),
            topRight: Radius.circular(tR),
          ),
          image: DecorationImage(
              fit: BoxFit.cover, image: CachedNetworkImageProvider(url)),
        ),
      ),
    );
  }

  Widget verticalDivider() {
    return Container(
      width: 2,
      height: double.maxFinite,
      color: kPrimaryColor,
    );
  }

  Widget horizontalDivider() {
    return Container(
      width: double.maxFinite,
      height: 2,
      color: kPrimaryColor,
    );
  }
}
