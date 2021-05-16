import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/views/widgets/clippers/isonline_rect.dart';

class BuildUserImageAndIsOnlineWidget extends StatelessWidget {
  final UsersBlock usersBlock;
  final MyUser user;
  final double width;
  BuildUserImageAndIsOnlineWidget(
      {Key key, this.usersBlock, String uid, this.width = 40})
      : user = usersBlock.getUserFromUid(uid),
        super(key: key);

  BuildUserImageAndIsOnlineWidget.fromUser(
      {Key key, this.user, this.width = 40, this.usersBlock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = width + (width / 6);
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                  color: user.isOnline ?? false ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(45)),
            ),
          ),
          Positioned(
            bottom: 3,
            top: height / 2,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: IsOnlinePainter(),
              child: Container(
                width: width,
                height: height - 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      user.isOnline
                          ? Colors.green.shade600.withOpacity(0.3)
                          : Colors.grey.shade600.withOpacity(0.3),
                      user.isOnline
                          ? Colors.green.shade300.withOpacity(0.1)
                          : Colors.grey.shade300.withOpacity(0.1)
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircleAvatar(
              radius: width / 2 - 2,
              backgroundImage: CachedNetworkImageProvider(user.photoURL),
            ),
          ),
        ],
      ),
    );
  }
}
