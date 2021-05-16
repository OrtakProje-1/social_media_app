import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/build_postitem_list.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/search_screen/search_screen.dart';
import 'package:social_media_app/views/screens/friendsScreen.dart';

class Home extends StatefulWidget {
  final ScrollController controller;
  Home({this.controller, Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with BuildPostItemList {
  EasyRefreshController _easyRefreshController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    _scrollController=ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userBlock.user.displayName),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(userBlock.user.photoURL),
          ),
        ),
        actions: <Widget>[
          Transform.rotate(
            angle: -pi / 2,
            child: IconButton(
              icon: Icon(
                Linecons.search,
              ),
              onPressed: () {
                Navigate.pushPage(context, SearchScreen());
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: profileBlock.friendsUid,
        initialData: profileBlock.friendsUid.valueWrapper.value,
        builder: (c, uids) {
          if (uids.hasData) if (uids.data.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Hiç Arkadaşınız Yok"),
                ),
                TextButton(
                    onPressed: () {
                      Navigate.pushPage(context, SearchScreen());
                    },
                    child: Text("Arkadaş Arayın")),
              ],
            );
          }
          return StreamBuilder<List<Post>>(
            stream: postsBlock.posts,
            initialData: postsBlock.posts.valueWrapper.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text("Burada Hiçbirşey Yok :((("),
                  );
                }
                return EasyRefresh.custom(
                  controller: _easyRefreshController,
                  scrollController: _scrollController,
                  topBouncing: false,
                  bottomBouncing: false,
                  onLoad: ()async{
                    print("onLoad()");
                  },
                  onRefresh: ()async{
                    print("onRefresh");
                  },
                  header:MaterialHeader(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade300)
                  ),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((c,i){
                          if (i == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: FriendsScreen(),
                            );
                          }
                          Post post = snapshot.data[i - 1];
                          return Padding(
                            padding:const EdgeInsets.symmetric(horizontal: 8),
                            child: buildPostItemList(
                                index: i - 1,
                                length: snapshot.data.length,
                                userUid: userBlock.user.uid,
                                post: post),
                          );
                        },
                      childCount: snapshot.data.length + 1,
                      ),
                    ),
                  ],
                );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          );
        },
      ),
    );
  }
}
