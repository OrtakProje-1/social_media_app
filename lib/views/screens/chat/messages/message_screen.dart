import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';

import 'components/body.dart';

class MessagesScreen extends StatefulWidget {
  final MyUser user;

  MessagesScreen({Key key, this.user}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<QueryDocumentSnapshot> selectedMessage = [];
  QueryDocumentSnapshot lastMessage;
  @override
  Widget build(BuildContext context) {
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return WillPopScope(
      onWillPop: () async {
        if (selectedMessage.isNotEmpty) {
          selectedMessage.clear();
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(
            selectedMessage.isNotEmpty, messagesBlock, userBlock, widget.user),
        body: Body(
          lastMessage: (QueryDocumentSnapshot lastMessage) {
            this.lastMessage = lastMessage;
        //   if(mounted) setState(() {});
          },
          rUid: widget.user.uid,
          selectedMessage: selectedMessage,
          removeSelected: (QueryDocumentSnapshot snap) {
            print("remove = " + snap.toString());
            selectedMessage.removeWhere((element) => element.id == snap.id);
            setState(() {});
          },
          longPressed: (QueryDocumentSnapshot snap) {
            selectedMessage.add(snap);
            setState(() {});
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(bool isSelect, MessagesBlock messagesBlock,
      UserBlock userBlock, MyUser user) {
    return AppBar(
      titleSpacing: 0,
      title: Container(
        child: Row(
          children: [
            CircleAvatar(
                radius: 17,
                backgroundImage:
                    CachedNetworkImageProvider(widget.user.photoURL)),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.all(4),
                height: AppBar().preferredSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.displayName,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (isSelect)
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () async {
              if(lastMessage!=null){
                if(selectedMessage.any((e) =>e.id==lastMessage.id)){
                 removeLastMessage(messagesBlock,userBlock.user.uid,widget.user.uid);
                }
              }
              selectedMessage.forEach((element) async {
                await messagesBlock.deleteMessage(element);
                selectedMessage.remove(element);
              });
              
              selectedMessage.clear();
              setState(() {});
            },
          ),
      ],
    );
  }

  Future<void> removeLastMessage(MessagesBlock messagesBlock,String myUid,String recUid)async{
    await messagesBlock.lastMessagesReference
                  .doc(myUid)
                  .collection("messages")
                  .doc(recUid)
                  .update(
                {
                  'lastMessage': "Bu mesaj silindi...",
                },
              );  
              await messagesBlock.lastMessagesReference
                  .doc(recUid)
                  .collection("messages")
                  .doc(myUid)
                  .update(
                {
                  'lastMessage': "Bu mesaj silindi...",
                },
              );
  }


}
