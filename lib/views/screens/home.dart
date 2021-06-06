import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/mixins/build_postitem_list.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/send_button.dart';
import 'package:social_media_app/views/screens/search_screen/search_screen.dart';
import 'package:social_media_app/views/widgets/refresher/my_easy_refresher.dart';

class Home extends StatefulWidget {
  final ScrollController? controller;
  Home({this.controller, Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with BuildPostItemList {
  BehaviorSubject<double>? elevation;

  @override
  void initState() {
    super.initState();

    elevation = BehaviorSubject.seeded(0);
    widget.controller!.addListener(() {
      getElevation();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: StreamBuilder<double>(
            stream: elevation,
            initialData: 0,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: AppBar(
                      elevation: snapshot.data,
                      shadowColor: kPrimaryColor.withOpacity(0.6),
                      title: Text.rich(
                        TextSpan(
                          text: "Social",
                          style: GoogleFonts.lobster(
                              fontSize: 25, color: kPrimaryColor),
                          children: [
                            TextSpan(
                              text: " Club",
                              style: GoogleFonts.lobster(
                                  fontSize: 22, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      automaticallyImplyLeading: false,
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
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 1,
                    color: kPrimaryColor.withOpacity(snapshot.data! / 8),
                  ),
                ],
              );
            }),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<String>>(
          stream: profileBlock.friendsUid,
          initialData: profileBlock.friendsUid.valueWrapper!.value,
          builder: (c, uids) {
            if (uids.hasData) if (uids.data!.isEmpty) {
              return MyEasyRefresher(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      BuildTextPost(),
                      Expanded(
                        child: Center(
                          child: Column(
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return StreamBuilder<List<Post>>(
              stream: postsBlock.posts,
              initialData: postsBlock.posts!.valueWrapper!.value,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return MyEasyRefresher(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            BuildTextPost(),
                            Expanded(
                              child: Center(
                                child: Text("Burada Hiçbirşey Yok :((("),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return MyEasyRefresher(
                    scrollController: widget.controller,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (BuildContext context, int i) {
                        if (i == 0) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: BuildTextPost(),
                              ),
                              //  FriendsScreen(),
                              Divider(
                                thickness: 2,
                                color: Colors.white24,
                              ),
                            ],
                          );
                        }
                        Post post = snapshot.data![i - 1];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: buildPostItemList(
                              index: i - 1,
                              length: snapshot.data!.length,
                              userUid: userBlock.user!.uid,
                              post: post),
                        );
                      },
                    ),
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            );
          },
        ),
      ),
    );
  }

  void getElevation() {
    double elev;
    try {
      elev = widget.controller!.offset.toInt() <= 0 ? 0 : 8;
    } catch (e) {
      elev = 0;
    }
    elevation!.add(elev);
  }
}

class BuildTextPost extends StatefulWidget {
  const BuildTextPost({
    Key? key,
  }) : super(key: key);

  @override
  _BuildTextPostState createState() => _BuildTextPostState();
}

class _BuildTextPostState extends State<BuildTextPost> {
    TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: 60,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(userBlock.user!.photoURL!)),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8, bottom: 10, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: Colors.white60, width: 0.5)),
              child: TextField(
                controller: message,
                cursorColor: Colors.white,
                cursorWidth: 1.5,
                onChanged: (s) {
                  setState(() {});
                },
                cursorRadius: Radius.circular(8),
                decoration: InputDecoration(
                    hintText: "Ne Düşünüyorsunuz...", border: InputBorder.none),
              ),
            ),
          ),
          SendButton(
            backgroundColor: Colors.white,
            size: 40,
            onPressed: message.text.isEmpty
                ? null
                : () async {
                    if (message.text.isNotEmpty) {
                      Post post = Post(
                          msg: message.text,
                          postTime:
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          senderUid: userBlock.user!.uid,
                          userName: userBlock.user!.displayName,
                          userPhotoUrl: userBlock.user!.photoURL);
                          setState(() {
                            message.clear();
                          });
                      await postsBlock.addPost(post);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
