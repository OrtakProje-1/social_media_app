import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/providers/postsBlock.dart';

typedef Builder=Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>);

class CommentsStream extends StatelessWidget {
  final Post post;
  final Builder builder;
  const CommentsStream({Key key,this.post,this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostsBlock postsBlock=Provider.of<PostsBlock>(context);
    return StreamBuilder(
      stream: postsBlock.commentsStream(post),
      builder: builder,
    );
  }
}