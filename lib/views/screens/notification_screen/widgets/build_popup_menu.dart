import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';

class BuildPopupMenu extends StatelessWidget {
  final ValueChanged<int>? onSelected;
  final int value;
  BuildPopupMenu({Key? key, this.onSelected, this.value = 0}) : super(key: key);
  final List<String> elemans = [
    "Hepsi",
    "Arkadaşlık",
    "Beğeni",
    "Yorum",
    "Bahsetme"
  ];

/**
 getStreamUnRead(
                          getType(elemans[i]), profileBlock, userBlock)
 */

  @override
  Widget build(BuildContext context) {
    NotificationBlock notificationBlock = NotificationBlock();
    return PopupMenuButton(
      color: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:Colors.white54,
          width: 1
        ),
      ),
      initialValue: value,
      itemBuilder: (_) {
        return List.generate(
          5,
          (i) {
            return PopupMenuItem(
              value: i,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(elemans[i],style: TextStyle(color: Colors.white60),),
                  SizedBox(
                    width: 10,
                  ),
                  if (elemans[i] != "Hepsi")
                    StreamBuilder<List<MyNotification>>(
                      stream: notificationBlock.notifications,
                      initialData:notificationBlock.notifications.valueWrapper!.value,
                      builder: (c, s) {
                        List<MyNotification> allNot=s.data!;
                        List<MyNotification> filteredNot= allNot.where((e) => e.nType==getType(elemans[i])).toList();
                        int? unreadCount=filteredNot.where((e) =>e.isRead==false).toList().length;
                        if (s.hasData)
                          return Text(
                            unreadCount.toString(),
                            style: TextStyle(
                                color: kPrimaryColor.withOpacity(0.7),
                                fontWeight: FontWeight.bold),
                          );
                        return Text(
                          "-",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
      onSelected: (dynamic i) => onSelected!(i),
    );
  }

  NType getType(String e) {
    if (e == "Arkadaşlık") return NType.FRIEND;
    if (e == "Beğeni") return NType.LIKE;
    if (e == "Yorum") return NType.COMMENT;

    return NType.SAVED;
  }

  Stream<QuerySnapshot> getStreamUnRead(
      NType type, ProfileBlock profileBlock, UserBlock userBlock) {
    return profileBlock
        .notification(userBlock.user!.uid)
        .where("nType", isEqualTo: type.index)
        .where("isRead", isEqualTo: false)
        .snapshots();
  }
}
