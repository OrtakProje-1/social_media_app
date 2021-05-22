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
      height:60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: profileBlock.streamFriends(userBlock.user.uid),
        builder: (c, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot usersQuery = snapshot.data;
            List<MyUser> users =
                usersQuery.docs.map((e) => MyUser.fromMap(e.data())).toList();
            if (users.isEmpty||users==null) {
              return BuildFriendsItem(user:me);
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: users.length+1,
              itemBuilder: (c, i) {
                if(i==0){
                  return BuildFriendsItem(user:me);
                }
                MyUser user = users[i-1];
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
                  child:BuildFriendsItem(user: user)
                );
              },
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class BuildFriendsItem extends StatelessWidget {
  const BuildFriendsItem({
    Key key,
    @required this.user,
  }) : super(key: key);

  final MyUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: BuildUserImageAndIsOnlineWidget.fromUser(
        user: user,
        width: 50,
      ),
    );
  }
}
