

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/mixins/picker_mixin.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/detail_screens/widgets/send_button.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/BuildImageListWidget.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_audio_widget.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_video_widget.dart';
import 'package:social_media_app/views/widgets/buttons/custom_elevated_button.dart';
import 'package:social_media_app/views/widgets/buttons/transparant_button.dart';
import 'package:social_media_app/views/widgets/post_item.dart';

class PostScreen extends StatefulWidget {
  final Post? post;
  PostScreen({Key? key, this.post}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin, PickerMixin {
  late AnimationController animationController;
  TextEditingController message = TextEditingController();
  bool showPickerButtons = false;
  List<PlatformFile> images = [];
  List<PlatformFile> audios = [];
  List<PlatformFile> videos = [];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    StorageBlock storageBlock = Provider.of<StorageBlock>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.post!.userName!),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8),
                children: [
                  PostItem(
                    img: "assets/images/cm7.jpg",
                    post: widget.post,
                    userUid: userBlock.user!.uid,
                    thisIsShowScreen: true,
                  ),
                  Divider(
                    height: 1,
                    color: kPrimaryColor,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: postsBlock
                        .postReference(widget.post!)
                        .collection("comments")
                        .orderBy("postTime",descending: true)
                        .snapshots(),
                    builder: (c, comments) {
                      if (comments.hasData) {
                        if (comments.data!.docs.isNotEmpty) {
                          List<QueryDocumentSnapshot> docs = comments.data!.docs;
                          return Column(
                            children: docs
                                .asMap()
                                .map((index, value) => MapEntry(
                                      index,
                                      buildColumnItem(docs[index],userBlock, index,docs.length)
                                    ))
                                .values
                                .toList(),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("Hadi ilk yorumu sen yap..."),
                            ),
                          );
                        }
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Hadi ilk yorumu sen yap..."),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: kPrimaryColor,
              height: 1,
            ),
            if (videos.isNotEmpty)
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: videos.isNotEmpty ? 150 : 0,
                child: BuildVideoWidget(
                    size: size,
                    videos: videos,
                    onPressedDeleteButton: (i) {
                      setState(() {
                        videos.removeAt(i);
                      });
                    }),
              ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: audios.isNotEmpty ? 70 : 0,
              child: BuildAudioWidget(
                  key: PageStorageKey("audio_widget"),
                  size: size,
                  audios: audios,
                  onPressedDeleteButton: (i) {
                    setState(() {
                      audios.removeAt(i);
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: images.isNotEmpty ? 150 : 0,
              child: BuildImageListWidget(
                  size: size,
                  images: images,
                  onPressedDeleteButton: (index) {
                    images.removeAt(index);
                    setState(() {});
                  }),
            ),
            AnimatedContainer(
              height: showPickerButtons ? 60 : 0,
              duration: Duration(milliseconds: 400),
              child: AnimatedOpacity(
                opacity: showPickerButtons ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      icon: Icons.image_outlined,
                      label: "Resim",
                      onPrimary: Colors.white,
                      primary: recMesColor,
                      shadowColor: Colors.transparent,
                      onPressed: videos.isNotEmpty || audios.isNotEmpty
                          ? null
                          : () async {
                              closePickerButtonsAndAnimation();
                              List<PlatformFile>? newImages =
                                  await getImagePicker();
                              setState(() {
                                images = newImages ?? [];
                              });
                            },
                      radius: 33,
                    ),
                    CustomElevatedButton(
                      icon: Icons.video_call_outlined,
                      onPrimary: Colors.white,
                      primary: recMesColor,
                      shadowColor: Colors.transparent,
                      label: "Video",
                      onPressed: images.isNotEmpty || audios.isNotEmpty
                          ? null
                          : () async {
                              closePickerButtonsAndAnimation();
                              List<PlatformFile>? video = await getVideoPicker();
                              setState(() {
                                videos = video ?? [];
                              });
                            },
                      radius:33,
                    ),
                    CustomElevatedButton(
                      icon: Icons.audiotrack_outlined,
                      onPrimary: Colors.white,
                      primary: recMesColor,
                      shadowColor: Colors.transparent,
                      label: "Ses",
                      onPressed: images.isNotEmpty || videos.isNotEmpty
                          ? null
                          : () async {
                              closePickerButtonsAndAnimation();
                              List<PlatformFile>? audio = await getAudioPicker();
                              setState(() {
                                audios = audio ?? [];
                              });
                            },
                      radius: 33,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 45,
              width: double.maxFinite,
              margin: EdgeInsets.only(
                  bottom: 5, top: 5, right: message.text.length > 0 ? 0 : 5),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 5,
                    child: Transform.rotate(
                      angle: pi / 4 * animationController.value,
                      child: Container(
                        width: 45,
                        child: TextButton(
                          child: Icon(
                            Icons.add,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            if (animationController.status ==
                                AnimationStatus.completed) {
                              showPickerButtons = false;
                              animationController.reverse();
                            } else {
                              showPickerButtons = true;
                              animationController.forward();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90)),
                        primary: recMesColor,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        onPrimary: kPrimaryColor.withOpacity(0.6)),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 400),
                    left: 55,
                    top: 0,
                    bottom: 0,
                    right: isThereData() ? 55 : 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      decoration: BoxDecoration(
                          color:recMesColor,
                          borderRadius: BorderRadius.circular(45)),
                      child: TextField(
                        cursorColor: Theme.of(context).textTheme.bodyText1!.color,
                        cursorRadius: Radius.circular(22),
                        cursorWidth: 1.5,
                        controller: message,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: Colors.transparent),
                        onChanged: (s) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Mesajınız",
                          isDense: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          helperStyle:
                              TextStyle(decoration: TextDecoration.none),
                          labelStyle: TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 400),
                    top: 0,
                    bottom: 0,
                    //bottom: isThereData() ? 0 : -55,
                    right: isThereData() ? 5 : -55,
                    child: SendButton(
                      iconColor: kPrimaryColor,
                      onPressed: () async {
                        List<MediaReference> imagesRef = [];
                        if (images.isNotEmpty) {
                          print("images null değil");
                          DateTime time = DateTime.now();
                          images.asMap().forEach((index, value) async {
                            MediaReference ref = await storageBlock.uploadImage(
                              userUid: userBlock.user!.uid,
                              file: File(value.path!),
                              index: index,
                              timeStamp: time.millisecondsSinceEpoch.toString(),
                              ext: StorageBlock.fileExt(value.name!),
                            );
                            if (ref != null) {
                              print(ref.downloadURL);
                              imagesRef.add(ref);
                              if (imagesRef.length == images.length) {
                                print("imagesUrl.length == images.lenght");
                                Post comment = Post(
                                    images: imagesRef,
                                    msg: message.text,
                                    likes: [],
                                    postTime: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    senderUid: userBlock.user!.uid,
                                    userName: userBlock.user!.displayName,
                                    userPhotoUrl: userBlock.user!.photoURL);
                                await postsBlock.addComment(comment, widget.post!,usersBlock);
                                clearDatas();
                              }
                              print("imagesUrl.length != images.lenght");
                            }
                          });
                        } else {
                          Post comment = Post(
                              images: imagesRef,
                              msg: message.text,
                              likes: [],
                              postTime: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              senderUid: userBlock.user!.uid,
                              userName: userBlock.user!.displayName,
                              savedPostCount: [],
                              userPhotoUrl: userBlock.user!.photoURL);
                          await postsBlock.addComment(comment, widget.post!,usersBlock);
                          clearDatas();
                          //updatePOST
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget buildColumnItem(QueryDocumentSnapshot data,UserBlock userBlock,int index,int length) {
    Post comment = Post.fromMap(data.data());
    return buildPostItem(userBlock, comment, index, length - 1);
  }

  Widget buildPostItem(
      UserBlock userBlock, Post post, int index, int lastIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          top: index % 2 == 0 && index != 0
              ? buildBorder()
              : buildTransparentBorder(),
          right: index % 2 == 1 ? buildBorder() : buildTransparentBorder(),
          left: index % 2 == 0 ? buildBorder() : buildTransparentBorder(),
          bottom: (index % 2 == 0 || index == 0) && index != lastIndex
              ? buildBorder()
              : buildTransparentBorder(),
        ),
      ),
      child: PostItem(
        userUid: userBlock.user!.uid,
        post: post,
        isComment: true,
      ),
    );
  }

  BorderSide buildTransparentBorder() =>
      BorderSide(width: 0, color: Colors.transparent);

  BorderSide buildBorder() {
    return BorderSide(
      width: 1,
      color: Colors.red.shade300,
    );
  }

  void clearDatas() {
    images.clear();
    videos.clear();
    audios.clear();
    message.clear();
    showPickerButtons = false;
    setState(() {});
  }

  bool isThereData() {
    return message.text.length > 0 ||
        audios.isNotEmpty ||
        videos.isNotEmpty ||
        images.isNotEmpty;
  }

  void closePickerButtonsAndAnimation() {
    setState(() {
      showPickerButtons = false;
      animationController.reverse();
    });
  }
}
