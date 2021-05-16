import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/profileScreen.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({Key key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    MyUser me = usersBlock.getUserFromUid(userBlock.user.uid);
    return Container(
      height: 100,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: profileBlock.streamFriends(userBlock.user.uid),
        builder: (c, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot usersQuery = snapshot.data;
            List<MyUser> users =
                usersQuery.docs.map((e) => MyUser.fromMap(e.data())).toList();
            if (users.isEmpty||users==null) {
              return Row(
                children: [
                  buildFriendsItem(usersBlock: usersBlock, me: me),
                ],
              );
            }
            return Row(
              children: [
                buildFriendsItem(usersBlock: usersBlock, me: me),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    physics: BouncingScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (c, i) {
                      MyUser user = users[i];
                      if (user.uid == userBlock.user.uid) {
                        return SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigate.pushPage(
                              context,
                              ProfileScreen(
                                user: user,
                              ));
                        },
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade400.withOpacity(0.5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BuildUserImageAndIsOnlineWidget.fromUser(
                                usersBlock: usersBlock,
                                user: user,
                                width: 50,
                              ),
                              Text(
                                user.displayName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class buildFriendsItem extends StatelessWidget {
  const buildFriendsItem({
    Key key,
    @required this.usersBlock,
    @required this.me,
  }) : super(key: key);

  final UsersBlock usersBlock;
  final MyUser me;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade400.withOpacity(0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BuildUserImageAndIsOnlineWidget.fromUser(
            usersBlock: usersBlock,
            user: me,
            width: 50,
          ),
          Text(
            me.displayName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
