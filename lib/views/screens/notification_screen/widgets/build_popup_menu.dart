import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';

class BuildPopupMenu extends StatelessWidget {
  final ValueChanged<int> onSelected;
  final int value;
  BuildPopupMenu({Key key,this.onSelected,this.value=0}) : super(key: key);
  final List<String> elemans = [
    "Hepsi",
    "Arkadaşlık",
    "Beğeni",
    "Yorum",
    "Bahsetme"
  ];

  @override
  Widget build(BuildContext context) {
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    return PopupMenuButton(
      initialValue: value,
      itemBuilder: (_) {
        return List.generate(
          5,
          (i) => PopupMenuItem(
            value: i,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(elemans[i]),
                SizedBox(
                  width: 10,
                ),
                if (elemans[i] != "Hepsi")
                  StreamBuilder<QuerySnapshot>(
                    stream: getStreamUnRead(
                        getType(elemans[i]), profileBlock, userBlock),
                    builder: (c, s) {
                      if (s.hasData)
                        return Text(
                          s.data.size.toString(),
                          style: TextStyle(color: Colors.red.shade300,fontWeight: FontWeight.bold),
                        );
                      return Text("-",style: TextStyle(color: Colors.red.shade300,fontWeight: FontWeight.bold),);
                    },
                  ),
              ],
            ),
          ),
        );
      },
      onSelected:(i)=>onSelected(i),
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
        .notification(userBlock.user.uid)
        .where("nType", isEqualTo: type.index)
        .where("isRead", isEqualTo: false)
        .snapshots();
  }
}
