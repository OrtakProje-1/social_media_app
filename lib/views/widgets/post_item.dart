

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/elapsed_time.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/post_screen.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:social_media_app/views/widgets/streams_widget/comments_stream_from_post.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';

class PostItem extends StatefulWidget {
  final Post? post;
  final String img;
  final String? userUid;
  final bool isComment;
  final bool thisIsShowScreen;
  final String showProfileUid;

  PostItem(
      {Key? key,
      this.isComment = false,
      this.showProfileUid="",
      this.post,
      this.img = "assets/images/cm8.jpeg",
      this.userUid,
      this.thisIsShowScreen = false})
      : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PageController? _controller;
  late bool likePost;

  bool showComments = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    if (widget.post?.likes != null) {
      if (widget.post!.likes!.isNotEmpty) {
        likePost =
            widget.post!.likes!.any((element) => element == widget.userUid);
      } else {
        likePost = false;
      }
    } else {
      likePost = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    PostsBlock postsBlock = Provider.of<PostsBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          ListTile(
            dense: true,
            leading: BuildUserImageAndIsOnlineWidget(
              usersBlock: usersBlock,
              uid: widget.post!.senderUid,
            ),
            onTap: (){
            if(widget.showProfileUid!=widget.post!.senderUid)  Navigate.pushPage(context,ProfileScreen(user:usersBlock.getUserFromUid(widget.post!.senderUid)));
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            focusColor: Constants.iconColor,
            horizontalTitleGap: kIsWeb ? 10 : 5,
            hoverColor: Constants.iconColor,
            title: Text(
              "${widget.post!.userName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "${TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.post!.postTime!)))}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_horiz_outlined),
              elevation: 8,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              tooltip: "Seçenekler",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              itemBuilder: (BuildContext context) {
                return [1]
                    .map((e) => PopupMenuItem(
                          height: 30,
                          enabled: widget.post!.senderUid == widget.userUid,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.delete_forever_outlined,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Sil",
                              ),
                            ],
                          ),
                          value: e,
                        ))
                    .toList();
              },
              onSelected: (int i) {
                if (i == 1) {
                  if (widget.post!.senderUid == widget.userUid) {
                    postsBlock.deletePost(widget.post!);
                  }
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
            ),
            padding: EdgeInsets.all(2),
            child: CommentsStream(
                post: widget.post,
                builder: (context, comments) {
                  return Column(
                    children: [
                      if (widget.post!.msg != null && widget.post!.msg != "")
                        Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              widget.post!.msg!,
                              textAlign: TextAlign.left,
                            )),
                      if (widget.post!.images != null &&
                          widget.post!.images!.isNotEmpty) ...[
                        if (widget.post!.images!.length == 1) ...[
                         Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(
                                        widget.post!.msg == null ||
                                                widget.post!.msg == ""
                                            ? 22
                                            : 12),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          widget.post!.images![0].downloadURL!),
                                    ),
                                  ),
                                ),
                        ],
                        if (widget.post!.images!.length > 1) ...[
                          AspectRatio(
                            aspectRatio: 10 / 6,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _controller,
                                  itemCount: widget.post!.images!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              widget.post!.images![index].downloadURL!,
                                              errorListener: () {
                                            print(
                                                "resim yüklenirken hata oluştu");
                                          }),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SmoothPageIndicator(
                                      controller: _controller!,
                                      count: widget.post!.images!.length,
                                      effect: ScrollingDotsEffect(
                                          activeDotScale: 1.3,
                                          dotColor: Colors.white60,
                                          radius: 5,
                                          activeDotColor: Colors.white,
                                          strokeWidth: 3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                      if (!widget.isComment)
                        Container(
                          width: double.maxFinite,
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical:0),
                          child: Row(
                            children: [
                              buildPostAction(
                                  icon:FontAwesome.thumbs_up,
                                  primary:likePost ? kPrimaryColor.withOpacity(0.7) : null,
                                  color: Colors.white,
                                  value: widget.post!.likes?.length,
                                  onPressed: () async {
                                    if (likePost) {
                                      await postsBlock.updateLike(
                                          false,
                                          widget.post!,
                                          widget.userUid,
                                          usersBlock);
                                    } else {
                                      await postsBlock.updateLike(
                                          true,
                                          widget.post!,
                                          widget.userUid,
                                          usersBlock);
                                    }
                                    setState(() {
                                      likePost = !likePost;
                                    });
                                  }),
                              buildPostAction(
                                  value: comments.hasData
                                      ? comments.data!.docs.length
                                      : 0,
                                  icon:Icons.messenger_outline_rounded,
                                  color: Colors.white,
                                  onPressed: () {
                                    if (!widget.thisIsShowScreen)
                                      Navigate.pushPage(
                                          context,
                                          PostScreen(
                                            post: widget.post,
                                          ));
                                  }),
                              // Spacer(),
                              buildPostAction(
                                icon: Icons.bookmark_border,
                                value: widget.post!.savedPostCount!.length,
                                color: Colors.white,
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                     
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Expanded buildPostAction(
      {IconData? icon, VoidCallback? onPressed, Color? color, int? value,Color? primary}) {
       
    value ??= Random().nextInt(2999);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical:0),
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            padding: EdgeInsets.all(0),
            textStyle: TextStyle(color: Colors.black),
            primary: primary,
          ),
          onPressed: onPressed != null ? onPressed : null,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                border: Border.all(
                    color:Colors.white24,
                    width: 1),
                color: primary),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                  SizedBox(width: 8,),
                  Center(child: Text(value.toString(),style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 
}
