

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/notification_screen/widgets/build_notification_item.dart';
import 'package:social_media_app/views/screens/notification_screen/widgets/build_popup_menu.dart';
import 'package:social_media_app/views/screens/notification_screen/widgets/empty_notifications.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> elemans = ["Hepsi", "Arkadaşlık", "Favori", "Yorum", "Bahsetme"];

  int pValue =0;
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Bildirimler"),
        centerTitle: true,
        actions: [
          BuildPopupMenu(value:pValue,onSelected: (i){
            setState(() {
              pValue=i;
            });
          },),
        ],
      ),
      body: bodyy(userBlock,pValue),
    );
  }

 

  Widget bodyy(UserBlock userBlock,int pValue) {
    NotificationBlock notificationBlock=NotificationBlock();
    NType? type=getType(pValue);
    return StreamBuilder<List<MyNotification>>(
      stream:notificationBlock.notifications,
      initialData:notificationBlock.notifications.valueWrapper!.value,
      builder: (c, snap) {
        print("notification ekranı");
        if (snap.hasData) {
          if (snap.data!.isNotEmpty) {
            List<MyNotification> notify = snap.data!;
            List<MyNotification> filterNot = getNotifications(notify, type);
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
              itemCount: filterNot.length,
              itemBuilder: (c, i) {
                return NotificationItem(
                  notification:filterNot[i],
                  index: i,
                  nextNotification: i <= filterNot.length - 2
                      ? filterNot[i + 1]
                      : null,
                );
              },
            );
          }
        }
        return EmptyNotifications();
      },
    );
  }

  List<MyNotification> getNotifications(List<MyNotification> nots,NType? type){
    if(type==null){
      return nots;
    }else{
      return nots.where((e) =>e.nType==type).toList();
    }
  }

   NType? getType(int i) {
    if (i == 0) return null;
    if (i == 1) return NType.FRIEND;
    if (i == 2) return NType.LIKE;
    if (i == 3) return NType.COMMENT;
    if (i == 4) return NType.SAVED;
  }
}
