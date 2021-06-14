import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/Post.dart';

class BuildImagePost extends StatefulWidget {
  final Post post;
  BuildImagePost({Key? key, required this.post}) : super(key: key);

  @override
  _BuildImagePostState createState() => _BuildImagePostState();
}

class _BuildImagePostState extends State<BuildImagePost> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 10 / 6,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(22),
          image: DecorationImage(
            fit: BoxFit.cover,
            image:
                CachedNetworkImageProvider(widget.post.images![0].downloadURL!),
          ),
        ),
      ),
    );
  }
}
