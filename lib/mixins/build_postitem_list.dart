import 'package:flutter/material.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/views/widgets/post_item.dart';
import 'package:social_media_app/util/extensions.dart';

class BuildPostItemList {
  Widget buildPostItemList(
      {Post? post,
      int? index,
      int? length,
      String? userUid,
      String profileUid = ""}) {
    if (index == length! - 1) {
      return Column(
        children: [
          PostItem(
            post: post,
            userUid: userUid,
            showProfileUid: userUid ?? "",
          ).fadeInList(index!, true),
          Container(
            height: AppBar().preferredSize.height + 7,
          ),
        ],
      );
    }

    return Column(
      children: [
        PostItem(
          post: post,
          userUid: userUid,
        ).fadeInList(index!, true),
        Divider(
          color: Colors.white,
        ),
      ],
    );
  }
}
