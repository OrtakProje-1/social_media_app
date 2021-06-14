

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';
import 'package:flutter/material.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  final String? rUid;
  final List<QueryDocumentSnapshot>? selectedMessage;
  final ValueChanged<QueryDocumentSnapshot>? longPressed;
  final ValueChanged<QueryDocumentSnapshot>? removeSelected;
  final ValueChanged<QueryDocumentSnapshot>? lastMessage;
  final ScrollController? controller;

  Body({this.rUid, this.longPressed, this.selectedMessage, this.removeSelected,this.lastMessage,this.controller});

  @override
  Widget build(BuildContext context) {
    bool select = selectedMessage!.isNotEmpty;
    MessagesBlock messagesBlock = Provider.of<MessagesBlock>(context);
    UserBlock userBlock = Provider.of<UserBlock>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: messagesBlock.getMessageStream(userBlock.user!.uid, rUid),
        builder: (context, snap) {
          return Column(
            children: [
              if (snap.hasData) ...[
                if (snap.data!.docs.isEmpty) ...[
                  empty(rUid,context),
                ],
                if (snap.data!.docs.isNotEmpty) ...[
                  buildMessageList(snap, select,userBlock,controller),
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

  Expanded buildMessageList(AsyncSnapshot<QuerySnapshot> snap, bool select,UserBlock userBlock,ScrollController? controller){
    lastMessage!(snap.data!.docs.first);
    String myUid=userBlock.user!.uid;
    return Expanded(
      child: ListView.builder(
          reverse: true,
          controller: controller,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 3),
          itemCount: snap.data!.size,
          itemBuilder: (context, index) {
            bool isSelected = selectedMessage!.any((e) => e.id == snap.data!.docs[index].id);
            ChatMessage message=ChatMessage.fromMap(snap.data!.docs[index].data());
            ChatMessage? nextMessage;
            ChatMessage? prevMessage;
            if(index<snap.data!.size-2){
              nextMessage=ChatMessage.fromMap(snap.data!.docs[index+1].data());
            }
            if(index>=1){
              prevMessage=ChatMessage.fromMap(snap.data!.docs[index-1].data());
            }

            return GestureDetector(
              onLongPress: () {
                print("Long pressed isSelect= " + isSelected.toString());
               if(!(message.isRemoved??true)&&message.sender!.uid==userBlock.user!.uid){
                  if (!isSelected)
                  longPressed!(snap.data!.docs[index]);
                else
                  removeSelected!(snap.data!.docs[index]);
               }
              },
              onTap: () {
                if(!(message.isRemoved??true)&&message.sender!.uid==userBlock.user!.uid){
                  if (select) {
                  if (isSelected) {
                    removeSelected!(snap.data!.docs[index]);
                  } else {
                    longPressed!(snap.data!.docs[index]);
                  }
                }
                }
              },
              child: Message(
                message:message,
                isSelected: isSelected,
                nextMessage:nextMessage,
                prevMessage:prevMessage,
              ),
            );
          }),
    );
  }

  Widget empty(String? uid,BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(child: Icon(Icons.lock_outline,size: 33,)),
                      Container(
                        width:20,
                        height: 2,
                        color: Colors.white,
                      ),
                      Container(
                        height: 20,
                        width: 2,
                        color: Colors.white
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.symmetric(vertical: 15,horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white60,
                              width: 1.6
                            ),
                          ),
                          child: Center(
                            child: Text("Metinleriniz uçtan uca şifrelenmiştir",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 2,
                        color: Colors.white
                      ),
                      Container(
                        width:20,
                        height: 2,
                        color: Colors.white,
                      ),
                      Container(child: Icon(Icons.lock_outline,size: 33,)),
                     
                    ],
                  ),
                ),
              ],
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

  Widget loading(String? uid) {
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
