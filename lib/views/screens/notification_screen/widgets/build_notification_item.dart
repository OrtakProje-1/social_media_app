

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/elapsed_time.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/post_screen.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationItem extends StatelessWidget {
  final MyNotification? notification;
  final MyNotification? nextNotification;
  final int? index;
   NotificationItem({
    Key? key,
    this.notification,
    this.index,
    this.nextNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFriend = notification!.nType == NType.FRIEND;
    SlidableController _controller = SlidableController();
    NotificationBlock notificationBlock = NotificationBlock();
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    MyUser me=MyUser.fromUser(userBlock.user!);
    return Container(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        controller: _controller,
        secondaryActions: [
          InkWell(
            onTap: () async {
                _controller.activeState!.close();
                await notificationBlock.deleteNotification(
                    notification!.nReceiver!.rUid, notification!);
              },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    "Sil",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()async{
               if (!notification!.isRead!) {
                  await notificationBlock.updateNotification(
                      notification!.nReceiver!.rUid,
                      notification!..isRead = true);
                }
                _controller.activeState!.close();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    "Okundu",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.grey.shade800,
            boxShadow: [
              BoxShadow(
                color: notification!.isRead!
                    ? Colors.grey.shade400
                    : kPrimaryColor,
                blurRadius: notification!.isRead! ? 4 : 6,
              ),
            ],
          ),
          child: ListTile(
            isThreeLine: isFriend ? true : false,
            leading:CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(notification!.nSender!.photoURL!),
            ),
            title: Text(notification!.nMessage!),
            subtitle: getSubTitle(isFriend,profileBlock,notification,me),
           // leading:getReadIcon(notification.nType), 
            onTap: () async {
              await notificationBlock.updateNotification(
                  userBlock.user!.uid,
                  notification!..isRead = !notification!.isRead!);
              if (notification!.post != null) {
                Navigate.pushPage(
                    context,
                    PostScreen(
                      post: notification!.post,
                    ));
              } if(notification!.nType==NType.FRIEND&&notification!.friend!=null){
                Navigate.pushPage(context,ProfileScreen(user: notification!.friend,));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getReadIcon(NType type){
    IconData icon;
    if (type==NType.COMMENT) {
      icon= Icons.comment_outlined;
    } else if(type==NType.FRIEND){
      icon= Icons.person_outlined;
    }else if(type==NType.LIKE){
      icon= Icons.favorite_border_rounded;
    }else{
      icon= Icons.bookmark_border_rounded;
    }
    return Container(
      height: double.maxFinite,
      child:Icon(icon,color: Colors.red.shade500,),
    );
  }

  Widget getSubTitle(bool isFriend,ProfileBlock profileBlock,MyNotification? notification,MyUser me,) {
    return !isFriend
        ? Text(TimeElapsed.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(int.parse(notification!.nTime!))))
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(notification!.nTime!)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async{
                      MyUser? friend=notification.friend;
                      if(friend!=null){
                        NotificationBlock notificationBlock=NotificationBlock();
                        await profileBlock.addFriend(me, friend);
                        await notificationBlock.deleteNotification(me.uid,notification);
                      }
                    },
                    child: Text("Kabul Et"),
                    style: TextButton.styleFrom(
                      primary: Colors.green.shade300,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.green.shade300,
                        width: 1
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  TextButton(
                    onPressed: () async{
                      NotificationBlock notificationBlock=NotificationBlock();
                      await notificationBlock.deleteNotification(me.uid,notification);
                    },
                    child: Text("Reddet"),
                    style: TextButton.styleFrom(
                      primary: Colors.red.shade300,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.red.shade300,
                        width: 1
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Color getNotificationColor(MyNotification not) {
    if (not == null) {
      return getNotificationColor(notification!);
    }
    return not.isRead! ? Colors.blue.shade200 : Colors.pink.shade200;
  }
}