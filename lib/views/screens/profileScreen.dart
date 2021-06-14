import 'dart:developer' as dev;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/mixins/build_postitem_list.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/biografi.dart';
import 'package:social_media_app/models/blocked_details.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/messages/message_screen.dart';
import 'package:social_media_app/views/screens/edit_profile/edit_profile_screen.dart';
import 'package:social_media_app/views/screens/search_screen/search_screen.dart';
import 'package:social_media_app/views/screens/search_screen/widgets/build_user_listile.dart';
import 'package:social_media_app/views/widgets/blurWidget.dart';
import 'package:social_media_app/views/widgets/buttons/profile_blur_button.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';

typedef Builder = Widget Function(
    {int? index, int? length, Post? post, String? userUid});

class ProfileScreen extends StatefulWidget {
  final MyUser? user;
  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(user: user);
}

class _ProfileScreenState extends State<ProfileScreen> with BuildPostItemList {
  int index = 0;
  MyUser? user;

  _ProfileScreenState({this.user});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    bool isMee = user!.uid == userBlock.user!.uid;
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
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              user!.photoURL!)),
                    ),
                    child: BlurWidget(
                      sigmaY: 20,
                      sigmaX: 20,
                      child: Container(
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -2,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(45)),
                      color: Theme.of(context).scaffoldBackgroundColor,
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
                            image: (user!.photoURL != null
                                    ? CachedNetworkImageProvider(
                                        user!.photoURL!)
                                    : AssetImage("assets/images/cm7.jpeg"))
                                as ImageProvider<Object>,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            leading: !isMee
                ? null
                : ProfileBlurButton(
                    icon: Icon(Linecons.pencil, color: Colors.white),
                    onPressed: () async{
                      Biografi? biografi=await Navigate.pushPage<Biografi>(context, EditProfileScreen(user: user!));
                      setState(() {
                        user=user?..biografi=biografi;
                      });
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
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await profileBlock.updateUserisOnline(
                        user!.uid!, false);
                    await userBlock.signOut(context);
                  },
                ),
              ],
              if (!isMee) ...[
                IconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () {
                    showMoreActions(context);
                  },
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
                      user!.displayName!.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user!.biografi != null) ...[
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded),
                              SizedBox(width: 8,),
                              Text(user!.biografi!.hakkimda ?? "Ben Social Club kullanıyorum..."),
                            ],
                          ),
                          if(user!.biografi!.numara!=null&&user!.biografi!.numara!="")...[
                            SizedBox(height: 8,),
                            Row(
                            children: [
                              Icon(Icons.phone_iphone_rounded),
                              SizedBox(width: 8,),
                              Text(user!.biografi!.numara!),
                            ],
                          ),
                          ],
                        ],
                        if (user!.biografi == null) ...[
                          Text("Ben Social Club kullanıyorum...")
                        ]
                      ],
                    ),
                  ),
                ),
                if (!isMee) ...[],
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(3),
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: kPrimaryColor.withOpacity(0.8)),
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
                        child: Center(
                            child: Text(
                          "Gönderiler",
                          style: TextStyle(
                              color: index == 0 ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
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
                        child: Center(
                            child: Text(
                          "Arkadaşlar",
                          style: TextStyle(
                              color: index == 0 ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )),
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
            getMyPosts(postsBlock, user!.uid, buildPostItemList),
          ],
          if (index == 1) ...[
            buildFriends(context, isMee),
          ]
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

  void showMoreActions(BuildContext context) {
    String myUid = Provider.of<UserBlock>(context, listen: false).user!.uid;
    ProfileBlock profileBlock =
        Provider.of<ProfileBlock>(context, listen: false);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context, listen: false);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BlurWidget(
              sigmaX: 5,
              sigmaY: 5,
              child: Container(
                height: 216,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white30, width: 0.5),
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 10,
                    ),
                    Spacer(),
                    StreamBuilder<List<MyUser>>(
                        stream: profileBlock.friendRequests,
                        initialData: profileBlock.friendRequests.value,
                        builder: (context, req) {
                          return StreamBuilder<List<MyUser>>(
                              stream: profileBlock.friends,
                              initialData: profileBlock.friends.value,
                              builder: (context, friends) {
                                bool isRequest = req.data!
                                    .any((e) => e.uid == user!.uid);
                                bool isFriend = friends.data!
                                    .any((e) => e.uid == user!.uid);
                                return InkWell(
                                  onTap: isRequest
                                      ? null
                                      : () async {
                                          if (isFriend) {
                                            await profileBlock.deleteFriend(
                                                myUid, user!.uid!);
                                          } else {
                                            await profileBlock
                                                .sendFriendshipRequest(
                                                    friend: user!,
                                                    sender: usersBlock
                                                        .getUserFromUid(
                                                            myUid)!);
                                          }
                                        },
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(isRequest
                                            ? "İstek gönderildi."
                                            : isFriend
                                                ? "Arkadaşlarımdan çıkar"
                                                : "Arkadaşlık isteği gönder"),
                                        Icon(isRequest
                                            ? Icons.person_outline_rounded
                                            : isFriend
                                                ? Icons
                                                    .person_remove_alt_1_outlined
                                                : Icons.person_add_alt),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigate.pushPage(
                            context, MessagesScreen(user: user!));
                      },
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mesaj Gönder"),
                            Icon(Icons.messenger_outline_rounded)
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    StreamBuilder<List<BlockedDetails>>(
                        stream: Provider.of<ProfileBlock>(context).blockedUsers,
                        initialData: profileBlock.blockedUsers.value,
                        builder: (context, blocked) {
                          bool isBlocked = blocked.data!
                              .any((e) => e.blockedUid == user!.uid!);
                          return InkWell(
                            onTap: () {
                              MyUser my = usersBlock.getUserFromUid(myUid)!;
                              Provider.of<ProfileBlock>(context, listen: false)
                                  .changeBlockedUser(my, user!.uid!);
                            },
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(isBlocked ? "Engeli Kaldır" : "Engelle"),
                                  Icon(Icons.block_outlined)
                                ],
                              ),
                            ),
                          );
                        }),
                    Spacer(),
                    Container(height: 10, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildFriends(BuildContext context, bool isMee) {
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    if (isMee) {
      return StreamBuilder<List<MyUser>>(
        stream: profileBlock.friends,
        initialData: profileBlock.friends.valueWrapper!.value,
        builder: (c, snap) {
          if (snap.hasData) if (snap.data!.length != 0) {
            List<MyUser> friends = snap.data!;
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (c, i) {
                  if (i == friends.length) {
                    return Container(
                      height: AppBar().preferredSize.height,
                    );
                  }
                  return BuildUserListile(
                    onPressed: () async {
                      List<String> friendsUid =
                          friends.map((e) => e.uid!).toList();
                      friendsUid.remove(friends[i].uid);
                      await profileBlock.deleteFriend(
                          userBlock.user!.uid, friends[i].uid!);
                      GetDatas().getFetchPosts(postsBlock, friendsUid);
                    },
                    shape: StadiumBorder(),
                    user: friends[i],
                    mesaj: "",
                    buttonBackgroundColor: Colors.transparent,
                    icon: Icon(
                      Icons.person_remove_alt_1_outlined,
                      color: kPrimaryColor,
                    ),
                    primary: kPrimaryColor,
                  );
                },
                childCount: friends.length + 1,
              ),
            );
          }
          return SliverToBoxAdapter(
            child: Center(
              child: TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Color(0xFFFFB3BB)),
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
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: profileBlock.streamFriends(user!.uid!),
        builder: (c, snap) {
          if (snap.hasData) {
            List<MyUser> friends=snap.data!.docs.map((e) =>MyUser.fromMap(e.data())).toList();
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (c,i){
                  if(i==friends.length){
                    return SizedBox(
                      height: AppBar().preferredSize.height,
                    );
                  }
                  return ListTile(
                    onTap:friends[i].uid ==userBlock.user!.uid ? null : (){
                      Navigate.pushPage(context,ProfileScreen(
                        user: friends[i],
                      ));
                    },
                    title: Text(friends[i].displayName!,style: TextStyle(fontWeight: FontWeight.bold),),
                    leading: BuildUserImageAndIsOnlineWidget(
                      usersBlock:usersBlock,
                      uid: friends[i].uid,
                    ),
                  );
                },
                childCount: friends.length+1,
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate((c, i) {
                return Shimmer.fromColors(
                  enabled: true,
                  baseColor: Color(0x157C7273),
                  highlightColor: Color(0xC2F0F0F0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Container(width: 150,height:20,color: Colors.red,),
                      leading: Container(
                        width: 40,
                        height: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }, childCount: 2),
            );
          }
        },
      );
    }
  }
}

Widget getMyPosts(
    PostsBlock postsBlock, String? uid, Builder buildPostItemList) {
  List<Post> posts = postsBlock.posts!.valueWrapper!.value
      .where((post) => post.senderUid == uid)
      .toList();
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
  return SliverToBoxAdapter(
    child: Center(
      child: Text("Hic gönderi yok."),
    ),
  );
}
