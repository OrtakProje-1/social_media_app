import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/picker_mixin.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/enum.dart';
import 'package:social_media_app/views/screens/chat/chats_screen.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/BuildImageListWidget.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_audio_widget.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_badge_widget.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_video_widget.dart';
import 'package:social_media_app/views/screens/notification_screen/notification_screen.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:social_media_app/views/screens/friendsScreen.dart';
import 'package:social_media_app/views/screens/chat/chats.dart';
import 'package:social_media_app/views/screens/home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:social_media_app/views/widgets/blurWidget.dart';
import 'package:social_media_app/views/widgets/bottom_appbar_notched_shape.dart';
import 'package:social_media_app/views/widgets/buttons/custom_elevated_button.dart';
import 'package:social_media_app/views/widgets/buttons/progress_buttons.dart';
import 'package:social_media_app/views/widgets/buttons/transparant_button.dart';
import 'package:social_media_app/views/widgets/fab_circular_menu.dart';
import 'package:fluttericon/linecons_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, PickerMixin {
  PageController? _pageController;
  ScrollController? _scrollController;
  AnimationController? _controller;
  int _page = 2;

  @override
  Widget build(BuildContext context) {
    StorageBlock storageBlock = Provider.of<StorageBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          ChatsScreen(
            key: PageStorageKey("chat"),
          ),
          NotificationsScreen(
            key: PageStorageKey("notifications"),
          ),
          Home(
            controller: _scrollController,
          ),
          ProfileScreen(
            key: PageStorageKey("profile"),
            user: Provider.of<UsersBlock>(context, listen: false)
                .getUserFromUid(userBlock.user!.uid),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryColor,
        shape: BottomAppbarNotchedShape(space: 0, radius: 20, spaceRadius: 4),
        child: BottomAppBar(
          shape: BottomAppbarNotchedShape(space: 3, radius: 25, spaceRadius: 4),
          elevation: 11,
          notchMargin: 0,
          color: Constants.bottombarBackgroundColor,
          child: Container(
            height: AppBar().preferredSize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.messenger_outline_rounded,
                    color: getCurrentColor(0),
                  ),
                  onPressed: () {
                    navigationTapped(0);
                  },
                ),
                BuildBadgeWidget(
                  stream: profileBlock
                      .notification(userBlock.user!.uid)
                      .where("isRead", isEqualTo: false)
                      .snapshots(),
                  widget: buildNotificationButton(),
                ),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                IconButton(
                  icon: Icon(
                    Typicons.home_outline,
                    size: 20,
                    color: getCurrentColor(2),
                  ),
                  onPressed: () {
                    navigationTapped(2);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_outline,
                    color: getCurrentColor(3),
                  ),
                  onPressed: () {
                    navigationTapped(3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FabCircularMenu(
        fabMargin: EdgeInsets.only(
          bottom: AppBar().preferredSize.height / 2 - 4,
        ),
        ringSecondColor: kPrimaryColor,
        animationCurve: Curves.linear,
        animationController: _controller,
        alignment: Alignment.bottomCenter,
        ringColor: Constants.bottombarBackgroundColor,
        ringDiameter: 200,
        ringWidth: 56,
        children: [
          TransparantButton(
            icon: Icon(
              Linecons.videocam,
              color: Colors.white,
            ),
            onPressed: () async {
              closeCircularMenu();
              newPostSenderUi(
                  context, storageBlock, userBlock, postsBlock, PostMode.VIDEO);
            },
          ),
          TransparantButton(
            icon: Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              closeCircularMenu();
              newPostSenderUi(
                  context, storageBlock, userBlock, postsBlock, PostMode.IMAGE);
            },
          ),
          TransparantButton(
            icon: Icon(
              Icons.audiotrack_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              closeCircularMenu();
              newPostSenderUi(
                  context, storageBlock, userBlock, postsBlock, PostMode.AUDIO);
            },
          ),
        ],
        //fabIconBorder: BeveledRectangleBorder(borderRadius: BorderRadius.circular(45)),
      ),
    );
  }

  IconButton buildNotificationButton() {
    return IconButton(
      icon: Icon(
        Icons.notifications_none_rounded,
        color: getCurrentColor(1),
      ),
      onPressed: () {
        navigationTapped(1);
      },
    );
  }

  Future<void> closeCircularMenu() async {
    if (_controller != null) {
      if (_controller!.status == AnimationStatus.completed) {
        await _controller!.reverse();
      }
    }
  }

  void newPostSenderUi(BuildContext context, StorageBlock storageBlock,
      UserBlock userBlock, PostsBlock postsBlock, PostMode mode) async {
    Size size = MediaQuery.of(context).size;
    TextEditingController message = TextEditingController();
    List<PlatformFile> images = [];
    List<PlatformFile> audios = [];
    List<PlatformFile> videos = [];
    ButtonState state = ButtonState.idle;
    double? indicatorValue;
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BlurWidget(
                  sigmaX: 5,
                  sigmaY: 5,
                  child: Container(
                    width: size.width,
                    height: size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white38,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Divider(
                          thickness: 10,
                          height: 10,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(8),
                            children: [
                              Center(
                                  child: Text(
                                "Yeni bir g??nderi olu??tur",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )),
                              Card(
                                elevation: 22,
                                color: Colors.transparent,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45),
                                  side: BorderSide(
                                    color: Colors.white10,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 15),
                                  child: TextField(
                                    scrollPhysics: BouncingScrollPhysics(),
                                    controller: message,
                                    cursorColor: Colors.white,
                                    cursorRadius: Radius.circular(8),
                                    cursorWidth: 1.5,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        hintText: "Mesaj??n?? buraya yaz...",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: CustomElevatedButton(
                                    icon: getPickerModeIconData(mode),
                                    label: getPickerModeText(mode),
                                    radius: 45,
                                    primary: Colors.white10,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.transparent,
                                    onPressed: () async {
                                      if (mode == PostMode.IMAGE) {
                                        List<PlatformFile>? newImages =
                                            await getImagePicker();
                                        newImages.forEach((e) {
                                          if (!images.contains(e))
                                            images.add(e);
                                        });
                                      } else if (mode == PostMode.AUDIO) {
                                        List<PlatformFile>? audio =
                                            await getAudioPicker();
                                        audios = audio;
                                      } else {
                                        List<PlatformFile>? video =
                                            await getVideoPicker();
                                        videos = video;
                                      }
                                      setState(() {});
                                    }),
                              ),
                              if (images.isNotEmpty) ...[
                                Divider(
                                  height: 1,
                                ),
                                BuildImageListWidget(
                                    size: size,
                                    images: images,
                                    onPressedDeleteButton: (int index) {
                                      setState(() {
                                        images.removeAt(index);
                                      });
                                    }),
                                Divider(
                                  height: 1,
                                ),
                              ],
                              if (audios.isNotEmpty) ...[
                                Divider(
                                  height: 1,
                                ),
                                BuildAudioWidget(
                                  audios: audios,
                                  onPressedDeleteButton: (i) {
                                    setState(() {
                                      audios.removeAt(i);
                                    });
                                  },
                                  size: MediaQuery.of(context).size,
                                ),
                                Divider(
                                  height: 1,
                                ),
                              ],
                              if (videos.isNotEmpty) ...[
                                Divider(
                                  height: 1,
                                ),
                                BuildVideoWidget(
                                    size: size,
                                    videos: videos,
                                    onPressedDeleteButton: (index) {}),
                                Divider(
                                  height: 1,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CustomProgressButton(
                              state: state,
                              value: indicatorValue,
                              onPressed: () async {
                                DateTime time = DateTime.now();
                                if (images.isNotEmpty) {
                                  List<MediaReference> imagesRef = [];
                                  images.asMap().forEach((index, value) async {
                                    setState(() {
                                      state = ButtonState.loading;
                                    });
                                    MediaReference ref =
                                        await storageBlock.uploadImage(
                                            file: File(value.path!),
                                            index: index,
                                            timeStamp: time
                                                .millisecondsSinceEpoch
                                                .toString(),
                                            ext: StorageBlock.fileExt(
                                                value.path!),
                                            userUid: userBlock.user!.uid);
                                    imagesRef.add(ref);
                                    if (imagesRef.length == images.length) {
                                      bool result = await sendPost(message.text, userBlock, postsBlock,imagesRef: imagesRef);
                                      if (result) {
                                        Navigator.pop(context);
                                      } else {
                                        setState(() {
                                          state = ButtonState.fail;
                                        });
                                      }
                                    }
                                  });
                                } else if (videos.isNotEmpty) {
                                  setState(() {
                                      state = ButtonState.loading;
                                    });
                                  MediaReference ref =
                                      await storageBlock.uploadVideo(
                                          file: File(videos[0].path!),
                                          userUid: userBlock.user!.uid,
                                          ext: StorageBlock.fileExt(
                                              videos[0].path!),
                                          timeStamp: time.millisecondsSinceEpoch
                                              .toString());
                                  bool result = await sendPost(message.text, userBlock, postsBlock,video: ref);
                                  if (result) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      state = ButtonState.fail;
                                    });
                                  }
                                } else if (audios.isNotEmpty) {
                                  setState(() {
                                      state = ButtonState.loading;
                                    });
                                  MediaReference ref =
                                      await storageBlock.uploadAudio(
                                          file: File(audios[0].path!),
                                          userUid: userBlock.user!.uid,
                                          ext: StorageBlock.fileExt(
                                              audios[0].path!),
                                          timeStamp: time.millisecondsSinceEpoch
                                              .toString());
                                  bool result = await sendPost(message.text, userBlock, postsBlock,audio: ref);
                                  if (result) {
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      state = ButtonState.fail;
                                    });
                                  }
                                } else {
                                  if (message.text.isNotEmpty) {
                                    bool result = await sendPost(message.text, userBlock, postsBlock);
                                    if (result) {
                                      setState(() {
                                        state = ButtonState.success;
                                      });
                                    } else {
                                      setState(() {
                                        state = ButtonState.fail;
                                      });
                                    }
                                  Navigator.pop(context);
                                  }
                                  setState(() {
                                        state = ButtonState.fail;
                                      });
                                      Future.delayed(Duration(milliseconds: 1500),(){
                                        setState(() {
                                        state = ButtonState.idle;
                                      });
                                      });
                                }
                              }),
                        ),
                        Divider(
                          thickness: 10,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData getPickerModeIconData(PostMode mode) {
    switch (mode) {
      case PostMode.AUDIO:
        return Icons.audiotrack_outlined;
      case PostMode.IMAGE:
        return Icons.image_outlined;
      case PostMode.VIDEO:
        return Linecons.videocam;
      default:
        return Icons.image_outlined;
    }
  }

  String getPickerModeText(PostMode mode) {
    switch (mode) {
      case PostMode.AUDIO:
        return "Ses Se??";
      case PostMode.IMAGE:
        return "Resim Ekle";
      case PostMode.VIDEO:
        return "Video Se??";
      default:
        return "Resim Ekle";
    }
  }

  Future<bool> sendPost( String msg,
      UserBlock userBlock, PostsBlock postsBlock,{List<MediaReference>? imagesRef,MediaReference? audio,MediaReference? video}) async {
    Post post = Post(
        senderUid: userBlock.user!.uid,
        msg: msg,
        postTime: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: userBlock.user!.displayName,
        userPhotoUrl: userBlock.user!.photoURL,
        video: video,
        audio: audio,
        images: imagesRef);
    return await postsBlock.addPost(post);
  }

  OutlineInputBorder getFormBorder({Color? color}) {
    if (color == null) color = Constants.iconColor;
    return OutlineInputBorder(
        gapPadding: 2,
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1));
  }

  Color getCurrentColor(int index) {
    if (_page == index) {
      return kPrimaryColor;
    } else {
      return Constants.disableIconColor;
    }
  }

  void navigationTapped(int page) {
    closeCircularMenu();
    _pageController!.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
    _controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}







/**
 
  // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: ClipRRect(
          //     clipper: Clipper(),
          //     borderRadius:BorderRadius.circular(12),
          //     child: BlurWidget(
          //       child: SnakeNavigationBar.color(
          //         padding: EdgeInsets.only(bottom: 7,left: 7,right: 7),
          //         snakeViewColor: Colors.black87,
          //         unselectedItemColor: Colors.white60,
          //         shadowColor: Colors.red,
          //         selectedItemColor: Colors.white,
          //         behaviour: SnakeBarBehaviour.floating,
          //         currentIndex: _page,
          //         onTap: navigationTapped,
          //         snakeShape: SnakeShape.rectangle,
          //         backgroundColor: Colors.indigo.withOpacity(0.8),//grey.shade300.withOpacity(0.2),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(12)),
          //         //shape: BeveledRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25),bottom:Radius.circular(25))),
          //         items: [
          //           BottomNavigationBarItem(
          //               icon: Icon(
          //                 Icons.home_outlined,
          //               ),
          //               activeIcon: Icon(Icons.home_filled),
          //               label: "Home"),
          //           BottomNavigationBarItem(
          //             icon: Icon(
          //               Icons.group_outlined,
          //             ),
          //             activeIcon: Icon(
          //               Icons.group,
          //             ),
          //             label: 'Users',
          //           ),
          //           BottomNavigationBarItem(
          //             icon: Icon(
          //               Icons.home_outlined,
          //             ),
          //             activeIcon: Icon(Icons.home_filled),
          //             label: 'Home',
          //           ),
          //           BottomNavigationBarItem(
          //             icon: Icon(
          //               Icons.notifications_outlined,
          //             ),
          //             activeIcon: Icon(Icons.notifications),
          //             label: 'Notifications',
          //           ),
          //           BottomNavigationBarItem(
          //             icon: Icon(
          //               Icons.person_outline,
          //             ),
          //             activeIcon: Icon(Icons.person),
          //             label: 'Profile',
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

 */

