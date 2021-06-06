import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/my_user.dart';

class BuildReceiverAppBarTitle extends StatelessWidget {
  final MyUser? user;
  final VoidCallback? onPressed;
  const BuildReceiverAppBarTitle({Key? key,this.user,this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: Row(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(user!.photoURL!),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap:onPressed,
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(4),
                height: AppBar().preferredSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.displayName!,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}