import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/views/screens/main_screen/widgets/build_badge_widget.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/notification_screen/widgets/build_notification_item.dart';
import 'package:social_media_app/views/screens/notification_screen/widgets/build_popup_menu.dart';
import 'package:social_media_app/views/screens/notification_screen/widgets/empty_notifications.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<String> elemans = ["Hepsi", "Arkadaşlık", "Favori", "Yorum", "Kayıt"];

  Stream<QuerySnapshot> stream;
  int pValue =0;
  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    stream = getAllStream(profileBlock, userBlock);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text("Bildirimler"),
          centerTitle: true,
          actions: [
            BuildPopupMenu(value: 0,),
          ],
        ),
        body: bodyy(userBlock, profileBlock, stream),
      ),
    );
  }

  void onSelected(int index, ProfileBlock profileBlock, UserBlock userBlock) {
    String value=elemans[index];
    print(value);
    if (value == "Hepsi") {
      stream = getAllStream(profileBlock, userBlock);
    } else if (value == "Arkadaşlık") {
      stream = getStreamUnRead(NType.FRIEND, profileBlock, userBlock);
    } else if (value == "Favori") {
      stream = getStreamUnRead(NType.LIKE, profileBlock, userBlock);
    } else if (value == "Yorum") {
      stream = getStreamUnRead(NType.COMMENT, profileBlock, userBlock);
    } else if (value == "Kayıt") {
      stream = getStreamUnRead(NType.SAVED, profileBlock, userBlock);
    }
    pValue=index;
    setState(() {});
  }

  Stream<QuerySnapshot> getAllStream(
      ProfileBlock profileBlock, UserBlock userBlock) {
    return profileBlock
        .notification(userBlock.user.uid)
        .orderBy("nTime", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getStreamUnRead(
      NType type, ProfileBlock profileBlock, UserBlock userBlock) {
    return profileBlock
        .notification(userBlock.user.uid)
        .where("nType", isEqualTo: type.index)
        .where("isRead", isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getStream(
      NType type, ProfileBlock profileBlock, UserBlock userBlock) {
    return profileBlock
        .notification(userBlock.user.uid)
        .where("nType", isEqualTo: type.index)
        .snapshots();
  }

  Widget bodyy(UserBlock userBlock, ProfileBlock profileBlock,
      Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (c, snap) {
        if (snap.hasData) {
          if (snap.data.docs.isNotEmpty) {
            List<QueryDocumentSnapshot> notify = snap.data.docs;
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: snap.data.size,
              itemBuilder: (c, i) {
                return NotificationItem(
                  notification: MyNotification.fromMap(notify[i].data()),
                  index: i,
                  nextNotification: i <= snap.data.size - 2
                      ? MyNotification.fromMap(notify[i + 1].data())
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
}
