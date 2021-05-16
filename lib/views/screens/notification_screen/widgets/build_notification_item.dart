import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/elapsed_time.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/post_screen.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationItem extends StatelessWidget {
  final MyNotification notification;
  final MyNotification nextNotification;
  final int index;
   NotificationItem({
    Key key,
    this.notification,
    this.index,
    this.nextNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(notification.nType);
    bool isFriend = notification.nType == NType.FRIEND;
    SlidableController _controller = SlidableController();
    NotificationBlock notificationBlock = NotificationBlock();
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    MyUser me=MyUser.fromUser(userBlock.user,token:userBlock.token);
    return Container(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        controller: _controller,
        secondaryActions: [
          Container(
            margin: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.red.shade600),
            child: TextButton(
              onPressed: () async {
                _controller.activeState.close();
                await notificationBlock.deleteNotification(
                    notification.nReceiver.rUid, notification);
              },
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
          Container(
            margin: EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.green.shade600),
            child: TextButton(
              onPressed: () async {
                if (!notification.isRead) {
                  await notificationBlock.updateNotification(
                      notification.nReceiver.rUid,
                      notification..isRead = true);
                }
                _controller.activeState.close();
              },
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
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: notification.isRead
                    ? Colors.blue.shade300
                    : Colors.pink.shade300,
                blurRadius: notification.isRead ? 4 : 6,
              ),
            ],
          ),
          child: ListTile(
            horizontalTitleGap:0,
            isThreeLine: isFriend ? true : false,
            trailing:Padding(
              padding: const EdgeInsets.only(left: 10),
              child: BuildUserImageAndIsOnlineWidget(
                uid: notification.nSender.uid,
                usersBlock: usersBlock,
              ),
            ),
            title: Text(notification.nMessage),
            subtitle: getSubTitle(isFriend,profileBlock,notification,me),
            leading:getReadIcon(notification.nType), 
            onTap: () async {
              await notificationBlock.updateNotification(
                  userBlock.user.uid,
                  notification..isRead = !notification.isRead);
              if (notification.post != null) {
                Navigate.pushPage(
                    context,
                    PostScreen(
                      post: notification.post,
                    ));
              } if(notification.nType==NType.FRIEND&&notification.friend!=null){
                Navigate.pushPage(context,ProfileScreen(user: notification.friend,));
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

  Widget getSubTitle(bool isFriend,ProfileBlock profileBlock,MyNotification notification,MyUser me,) {
    return !isFriend
        ? Text(TimeElapsed.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(int.parse(notification.nTime))))
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
                  int.parse(notification.nTime)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async{
                      MyUser friend=notification.friend;
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
      return getNotificationColor(notification);
    }
    return not.isRead ? Colors.blue.shade200 : Colors.pink.shade200;
  }
}
/*

Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      elevation: 8,
      color: !notification.isRead ? Colors.blue.shade100 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        trailing:getIcon(notification.nType),
        title: Text(notification.nMessage),
        subtitle: Text(TimeElapsed.fromDateTime(DateTime.fromMillisecondsSinceEpoch(int.parse(notification.nTime)))),
        leading:BuildUserImageAndIsOnlineWidget(uid: notification.nSender.uid,usersBlock: usersBlock,),
        onTap: ()async{
          await notificationBlock.updateNotification(userBlock.user.uid,notification..isRead=!notification.isRead);
          if(notification.post!=null){
            Navigate.pushPage(context,PostScreen(post: notification.post,));
          }
        },
      ),
    );

 */