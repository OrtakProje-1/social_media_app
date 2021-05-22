import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:flutter/material.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  final String rUid;
  final List<QueryDocumentSnapshot> selectedMessage;
  final ValueChanged<QueryDocumentSnapshot> longPressed;
  final ValueChanged<QueryDocumentSnapshot> removeSelected;
  final ValueChanged<QueryDocumentSnapshot> lastMessage;

  Body(
      {this.rUid, this.longPressed, this.selectedMessage, this.removeSelected,this.lastMessage});

  @override
  Widget build(BuildContext context) {
    bool select = selectedMessage.isNotEmpty;
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: messagesBlock.getMessageStream(userBlock.user.uid, rUid),
        builder: (context, snap) {
          return Column(
            children: [
              if (snap.hasData) ...[
                if (snap.data.docs.isEmpty) ...[
                  empty(rUid),
                ],
                if (snap.data.docs.isNotEmpty) ...[
                  buildMessageList(snap, select,userBlock),
                  ChatInputField(
                    rUid: rUid,
                    noMessage: false,
                  ),
                ],
              ],
              if (!snap.hasData) ...[
                loading(rUid),
              ],
            ],
          );
        });
  }

  Expanded buildMessageList(AsyncSnapshot<QuerySnapshot> snap, bool select,UserBlock userBlock){
    lastMessage(snap.data.docs.first);
    return Expanded(
      child: ListView.builder(
          reverse: true,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 3),
          itemCount: snap.data.size,
          itemBuilder: (context, index) {
            bool isSelected = selectedMessage.any((e) => e.id == snap.data.docs[index].id);
            ChatMessage message=ChatMessage.fromMap(snap.data.docs[index].data());
            return GestureDetector(
              onLongPress: () {
                print("Long pressed isSelect= " + isSelected.toString());
               if(!(message.isRemoved??true)&&message.senderUid==userBlock.user.uid){
                  if (!isSelected)
                  longPressed(snap.data.docs[index]);
                else
                  removeSelected(snap.data.docs[index]);
               }
              },
              onTap: () {
                if(!(message.isRemoved??true)&&message.senderUid==userBlock.user.uid){
                  if (select) {
                  if (isSelected) {
                    removeSelected(snap.data.docs[index]);
                  } else {
                    longPressed(snap.data.docs[index]);
                  }
                }
                }
              },
              child: Message(
                message:message,
                isSelected: isSelected,
              ),
            );
          }),
    );
  }

  Widget empty(String uid) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text("Hiç Mesajınız Yok"),
            ),
          ),
          ChatInputField(
            rUid: uid,
            noMessage: true,
          ),
        ],
      ),
    );
  }

  Widget loading(String uid) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(""),
            ),
          ),
          ChatInputField(
            rUid: uid,
            noMessage: false,
          ),
        ],
      ),
    );
  }
}
