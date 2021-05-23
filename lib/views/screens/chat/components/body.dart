import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/const.dart';
import 'package:social_media_app/util/router.dart';
import 'package:social_media_app/views/screens/chat/messages/message_screen.dart';
import 'package:social_media_app/views/screens/chat/models/chat.dart';
import 'package:social_media_app/views/widgets/userWidgets/BuildUserImageAndIsOnlineWidget.dart';
import 'chat_card.dart';

class Body extends StatefulWidget {
  final ScrollController scrollController;
  Body({Key key, this.scrollController}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ScrollController _scrollController;
  BehaviorSubject<double> shadow;
  TextEditingController searchUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    shadow = BehaviorSubject.seeded(0);
    _scrollController.addListener(() {
      getShadow();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileBlock profileBlock = Provider.of<ProfileBlock>(context);
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UsersBlock usersBlock = Provider.of<UsersBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return StreamBuilder<List<Chat>>(
        stream: messagesBlock.lastMessagesStream,
        initialData:messagesBlock.lastMessagesStream.value,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Yükleniyor..."),
            );
          }
         
          List<Chat> chats = snapshot.data??[];
          List<Chat> filteredChat=chats;
          if(chats.isNotEmpty&&searchUser.text.isNotEmpty){
            filteredChat=chats.where((e) =>e.name.toLowerCase().contains(searchUser.text.toLowerCase())).toList();
          }
          return ListView.builder(
            controller: widget.scrollController,
            physics: BouncingScrollPhysics(),
            itemCount:filteredChat.length+1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 2, vertical: 10),
                      child: Container(
                        decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(12),
                        color:  Colors.grey[850],//Color(0xff292d32),
                       
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.white.withOpacity(0.2),
                            offset: Offset(-3,-3)
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(3,3)
                          ),
                        ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 10),
                          child: TextField(
                            controller: searchUser,
                            onChanged: (s) {
                              setState(() {});
                            },
                            cursorRadius: Radius.circular(8),
                            cursorColor:Theme.of(context).textTheme.bodyText1.color,
                            cursorWidth: 1.5,
                            decoration: InputDecoration(
                                hintText: "Kimi arıyorsun...",
                                border: InputBorder.none,
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                suffixIcon: Icon(
                                  Icons.person_search_outlined,
                                  color: Colors.grey.shade400,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      margin: EdgeInsets.only(
                          left: kDefaultPadding / 2, bottom: 15, top: 15),
                      child: StreamBuilder<List<MyUser>>(
                        stream: profileBlock.friends,
                        initialData: profileBlock.friends.valueWrapper.value,
                        builder: (c, snap) {
                          List<MyUser> onlineUsers = snap.data.where((e) => e.isOnline).toList();
                          List<MyUser> filteredUser=onlineUsers;
                          if(onlineUsers.isNotEmpty&&searchUser.text.isNotEmpty){
                            filteredUser=onlineUsers.where((e) => e.displayName.toLowerCase().contains(searchUser.text.toLowerCase())).toList();
                          }
                          return (filteredUser.isNotEmpty)
                              ? ListView.builder(
                                  controller: _scrollController,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filteredUser.length,
                                  itemBuilder: (c, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigate.pushPage(
                                            context,
                                            MessagesScreen(
                                              user: filteredUser[i],
                                            ));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: i == 0 ? 0 : 8, right: 8),
                                        child: BuildUserImageAndIsOnlineWidget
                                            .fromUser(
                                          user: filteredUser[i],
                                          width: 55,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(child: Text("Burada Kimse Yok."),);
                        },
                      ),
                    ),
                    if (filteredChat.isEmpty)
                      Container(
                          height: 100,
                          child:Center(child: Text("Burada Kimse Yok.")))
                  ],
                );
              }
              return ChatCard(
                chat: filteredChat[index - 1],
                press: () {
                  Navigate.pushPage(
                      context,
                      MessagesScreen(
                        user: usersBlock.getUserFromUid(filteredChat[index - 1].senderUid==userBlock.user.uid ? filteredChat[index - 1].rUid : filteredChat[index - 1].senderUid),
                      ));
                },
              );
            },
          );
        });
  }

  void getShadow() {
    double shad;
    try {
      shad = _scrollController?.offset?.toInt() <= 0 ? 0 : 8;
    } catch (e) {
      shad = 0;
    }
    shadow.add(shad);
  }
}
