import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/views/screens/search_screen/widgets/build_user_listile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchQuery = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45))),
          child: Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: _searchQuery,
            cursorColor: Colors.red.shade300,
            cursorWidth: 1.5,
            onChanged: (s) {
              setState(() {});
            },
            cursorRadius: Radius.circular(3),
            decoration: InputDecoration(
                border: InputBorder.none, hintText: "Kimi arıyorsunuz ?"),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: profileBlock.streamFriendRequest(userBlock.user.uid),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> friendRequests) {
          List<MyUser> requests = [];
          if (friendRequests.hasData) {
            requests = friendRequests.data.docs
                .map((e) => MyUser.fromMap(e.data()))
                .toList();
          }else{
            return SizedBox();
          }
          return StreamBuilder<List<MyUser>>(
            stream: usersBlock.users,
            initialData:usersBlock.users.valueWrapper.value,
            builder: (c, snap) {
              if (snap.hasData) if (snap.data.isNotEmpty) {
                List<MyUser> users = snap.data;

                List<MyUser> filteredUsers = _searchQuery.text.isEmpty
                    ? users
                    : users
                        .where((element) => element.displayName
                            .toLowerCase()
                            .contains(_searchQuery.text.toLowerCase()))
                        .toList();
                return ListView.separated(
                  separatorBuilder: (c, i) {
                    return Divider(
                      color: Colors.orange,
                    );
                  },
                  itemCount: filteredUsers.length,
                  itemBuilder: (c, i) {
                    MyUser user = filteredUsers[i];
                    bool isMee = user.uid == userBlock.user.uid;
                    bool isRequest=requests.any((e) =>e.uid==user.uid);
                    return BuildUserListile(
                      onPressed: isMee||isRequest
                          ? null
                          : () async {
                              await profileBlock.sendFriendshipRequest(
                                  friend: user,
                                  sender: usersBlock
                                      .getUserFromUid(userBlock.user.uid));
                            },
                      user: user,
                      textColor: isMee||isRequest ? Colors.red.shade100 : null,
                      icon: Icon(
                        isRequest ? Icons.person_outlined : Icons.person_add_alt,
                        color:
                            isMee||isRequest ? Colors.red.shade100 : Colors.red.shade300,
                      ),
                      mesaj: isMee ? "Bu sizsiniz" :isRequest ? "İstek Gönderildi" : "Arkadaş Ekle",
                    );
                  },
                );
              }
              return Center(
                child: Text("Böyle bir kullanıcı yok"),
              );
            },
          );
        },
      ),
    );
  }
}
