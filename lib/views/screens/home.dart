
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/mixins/build_postitem_list.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/providers/get_datas.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/search_screen/search_screen.dart';
import 'package:social_media_app/views/screens/friendsScreen.dart';

class Home extends StatefulWidget {
  final ScrollController? controller;
  Home({this.controller, Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with BuildPostItemList {
  EasyRefreshController? _easyRefreshController;
  DateTime? lastUpdated;
  bool readyUpdate = true;
  BehaviorSubject<double>? elevation;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
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
              return AppBar(
                elevation: snapshot.data,
                title: Text(userBlock.user!.displayName!),
                centerTitle: true,
                leading: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image:CachedNetworkImageProvider(userBlock.user!.photoURL!),
                      ),
                    ),
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
              );
            }),
      ),
      body: StreamBuilder<List<String?>>(
        stream: profileBlock.friendsUid,
        initialData: profileBlock.friendsUid!.valueWrapper!.value,
        builder: (c, uids) {
          if (uids.hasData) if (uids.data!.isEmpty) {
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
            initialData: postsBlock.posts!.valueWrapper!.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Burada Hiçbirşey Yok :((("),
                  );
                }
                return EasyRefresh.custom(
                  controller: _easyRefreshController,
                  scrollController: widget.controller,
                  onRefresh: () async {
                    GetDatas datas = GetDatas();
                    _easyRefreshController!.callLoad();
                    if (readyUpdate) {
                      Future.delayed(Duration(seconds: 5), () {
                        setState(() {
                          readyUpdate = true;
                        });
                      });
                      await datas.getAllDatas(context, userBlock.user!.uid);
                      lastUpdated = DateTime.now();
                      readyUpdate = false;
                    } else {
                      print("Güncelleme süre dolmadı");
                    }
                  },
                  header: ClassicalHeader(
                      bgColor: Colors.grey.shade100,
                      infoText: !readyUpdate
                          ? "Yenileme hazır değil"
                          : lastUpdated == null
                              ? ""
                              : "Son güncelleme ${lastUpdated!.hour}:${lastUpdated!.minute}",
                      refreshingText: "Yükleniyor...",
                      refreshFailedText: "Hata Oluştu.",
                      refreshReadyText: "Yenilemek için bırakın.",
                      refreshText: "Yenilemek için çekin.",
                      refreshedText: "Tamamlandı"),
                  footer: null,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (c, i) {
                          if (i == 0) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FriendsScreen(),
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
                        childCount: snapshot.data!.length + 1,
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
