import 'dart:developer' as dev;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/build_postitem_list.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/search_screen/search_screen.dart';
import 'package:social_media_app/views/screens/search_screen/widgets/build_user_listile.dart';
import 'package:social_media_app/views/widgets/buttons/custom_elevated_button.dart';
import 'package:social_media_app/views/widgets/buttons/profile_blur_button.dart';

typedef Builder = Widget Function(
    {int index, int length, Post post, String userUid});

class ProfileScreen extends StatefulWidget {
  final MyUser user;
  ProfileScreen({Key key, @required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with BuildPostItemList {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    bool isMee=widget.user.uid == userBlock.user.uid;
    bool isRequest=profileBlock.isRequest(widget.user.uid);
    bool isFriend=profileBlock.isFriend(widget.user.uid);
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            expandedHeight: size.width * 0.6,
            floating: false,
            pinned: false,
            snap: false,
            flexibleSpace: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Image.asset(
                    "assets/images/cm0.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: size.width * 0.5,
                  bottom: 0,
                  width: size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(33)),
                      color:Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: size.width,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                            image: widget.user.photoURL != null
                                ? CachedNetworkImageProvider(
                                    widget.user.photoURL)
                                : AssetImage("assets/images/cm7.jpeg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            leading: !isMee
                ? ProfileBlurButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  )
                : ProfileBlurButton(
                    icon: Icon(Linecons.pencil, color: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
            actions: [
              if (isMee) ...[
                //   ProfileBlurButton(
                //   icon: Icon(Linecons.pencil,color: Colors.white),
                //   onPressed: () {
                //     Navigator.maybePop(context);
                //   },
                // ),
                ProfileBlurButton(
                  icon: Icon(
                    FontAwesome5.sign_out_alt,
                    color: Colors.white,
                  ),
                  onPressed: () => userBlock.signOut(context),
                ),
              ],
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      widget.user?.displayName?.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: buildFollowWidget("Takipçi")),
                      Container(width:1,color: Colors.red.shade100,height: 20,),
                      Expanded(child: buildFollowWidget("Takip ettiklerim"))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    """Kullanıcı Hakkında Bilgi Kullanıcı Hakkında Bilgi Kullanıcı Hakkında Bilgi Kullanıcı Hakkında Bilgi Kullanıcı Hakkında Bilgi Kullanıcı Hakkında BilgiKullanıcı Hakkında Bilgi""",
                    textAlign: TextAlign.center,
                  ),
                ),
                if(!isMee)...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade100,
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isRequest ? Icons.person_outline_rounded :isFriend ? Icons.person_remove_alt_1_outlined : Icons.person_add_alt,color: Colors.red.shade300,),
                        SizedBox(width: 10,),
                        Text(isRequest ? "İstek gönderildi." :isFriend ? "Arkadaşlarımdan çıkar" : "Arkadaşlık isteği gönder",style:TextStyle(color: Colors.red.shade300))
                      ],
                    ),
                    onPressed:isRequest ? null : (){},
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade100,
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.block_outlined,color: Colors.red.shade300,),
                        SizedBox(width: 10,),
                        Text("Bu kullanıcıyı engelle",style:TextStyle(color: Colors.red.shade300))
                      ],
                    ),
                    onPressed: (){},
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.shade100,
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notification_important_outlined,color: Colors.red.shade300,),
                        SizedBox(width: 10,),
                        Text("Bu kullanıcıyı şikayet et",style:TextStyle(color: Colors.red.shade300))
                      ],
                    ),
                    onPressed: (){},
                  ),
                ],
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(3),
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Color(0xFFFFB3BB)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (index == 1)
                          setState(() {
                            index -= 1;
                          });
                        dev.log("Gönderiler");
                      },
                      child: Container(
                        child: Center(child: Text("Gönderiler",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (index == 0)
                          setState(() {
                            index += 1;
                          });
                        dev.log("Arkadaşlar");
                      },
                      child: Container(
                        child: Center(child: Text("Arkadaşlar",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                        decoration: BoxDecoration(
                          color: index == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (index == 0) ...[
            getMyPosts(postsBlock, widget.user.uid, buildPostItemList),
          ],
          if (index == 1)
            StreamBuilder<List<MyUser>>(
              stream: profileBlock.friends,
              initialData: profileBlock.friends.valueWrapper.value,
              builder: (c, snap) {
                if (snap.hasData) if (snap.data.length != 0) {
                  List<MyUser> friends = snap.data;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (c, i) {
                        return BuildUserListile(
                          mesaj: "Arkadaşı sil",
                          onPressed: () {},
                          user: friends[i],
                          icon: Icon(
                            Icons.person_remove_alt_1_outlined,
                            color: Colors.red.shade300,
                          ),
                        );
                      },
                      childCount: friends.length,
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Center(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFFFB3BB)),
                        onPressed: () {
                          Navigate.pushPage(context, SearchScreen());
                        },
                        child: Text(
                          "Arkadaş Ara.",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget buildFollowWidget(String txt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          Random().nextInt(1000).toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(
          width: 4,
        ),
        Text("Takip ediliyor"),
      ],
    );
  }
}

Widget getMyPosts(
    PostsBlock postsBlock, String uid, Builder buildPostItemList) {
  List<Post> posts = postsBlock.posts.valueWrapper.value
      .where((post) => post.senderUid == uid)
      .toList();
  if (posts != null) {
    if (posts.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext c, int index) {
            Post post = posts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: buildPostItemList(
                index: index,
                length: posts.length,
                post: post,
                userUid: uid,
              ),
            );
          },
          childCount: posts.length,
        ),
      );
    }
  }
  return SliverToBoxAdapter(
    child: Center(
      child: Text("Hic gönderi yok."),
    ),
  );

  // return SliverList(
  //   delegate: SliverChildBuilderDelegate((c, i) {
  //     return Shimmer.fromColors(
  //       enabled: true,
  //       baseColor: Color(0x44FFB3BB),
  //       highlightColor: Color(0x5031DAA2),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: EmptyPostItem(),
  //       ),
  //     );
  //   }, childCount: 5),
  // );
}

/*
SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext c, int idx) {
              return AspectRatio(
                aspectRatio:index==0 ? 1 / 1 : 1/0.6,
                child: Container(
                  height: index==0 ? 123 : 63,
                  margin: EdgeInsets.all(10),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Color(0xFFFFB3BB)),
                ),
              );
            }, childCount: 5),
          ),
*/