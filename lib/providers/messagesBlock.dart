import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/database/firebase_yardimci.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/storageBlock.dart';
import 'package:social_media_app/providers/userBlock.dart';
import 'package:social_media_app/views/screens/chat/models/chat.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';

class MessagesBlock {
  MessagesBlock() {
    _firestore = FirebaseYardimci().firestore;
    init();
  }

  FirebaseFirestore _firestore;
  BehaviorSubject<List<Chat>> lastMessagesStream;
  StreamSubscription lastMessagesSubscription;

  init() {
    lastMessagesStream = BehaviorSubject.seeded([]);
  }

  clearData() {
    lastMessagesStream.add([]);
    lastMessagesSubscription?.cancel();
  }

  Future<void> fetchLastMessages(String uid) async {
    lastMessagesSubscription = getMessagesStream(uid).listen((event) {
      List<Chat> lastMessages = event.docs
          .map((e) => Chat.fromMap(e.data()).copyWith(docRef: e.reference))
          .toList();
      lastMessagesStream.add(lastMessages);
    });
  }

  CollectionReference get messagesReference =>
      _firestore.collection("Messages");
  CollectionReference get lastMessagesReference =>
      _firestore.collection("LastMessages");
  CollectionReference messagesColReference(String docId) =>
      messagesReference.doc(docId).collection("messages");

  Stream<QuerySnapshot> getMessageStream(String uid1, String uid2) {
    String reference = getDoc(uid1, uid2);
    return messagesReference
        .doc(reference)
        .collection("messages")
        .orderBy("messageTime", descending: true)
        .snapshots();
  }

  Future<void> deleteMessage(QueryDocumentSnapshot doc,BuildContext context) async {
    ChatMessage message= ChatMessage.fromMap(doc.data());
    await _deleteMedia(message,context);
    await doc.reference.set({
      "text": "Bu mesaj silindi...",
      "isRemoved": true,
      "images":null,
      "messageType":0
    }, SetOptions(merge: true));
    
  }

  Future<void> _deleteMedia(ChatMessage mes,BuildContext context)async{
    await _deleteMessageImages(mes,context);
    await _deleteMessageVideo(mes,context);
    await _deleteMessageAudio(mes,context);
    await _deleteMessageFile(mes,context);
  }

  Future<void> _deleteMessageImages(ChatMessage mes,BuildContext context)async{
    if(mes.images!=null){
      if(mes.images.isNotEmpty){
        StorageBlock storageBlock=Provider.of<StorageBlock>(context,listen: false);
        UserBlock userBlock=Provider.of<UserBlock>(context,listen: false);
        mes.images.forEach((image)async{
          print("resim siliniyor = "+image.ref);
          await storageBlock.deleteImage(userBlock.user.uid,image.ref);
        });
      }
    }
  }
  Future<void> _deleteMessageVideo(ChatMessage mes,BuildContext context)async{
    if(mes.video!=null){
        StorageBlock storageBlock=Provider.of<StorageBlock>(context,listen: false);
        UserBlock userBlock=Provider.of<UserBlock>(context,listen: false);
        print("resim siliniyor = "+mes.video.ref);
        await storageBlock.deleteVideo(userBlock.user.uid,mes.video.ref);
        
    }
  }
  Future<void> _deleteMessageAudio(ChatMessage mes,BuildContext context)async{
    if(mes.audio!=null){
        StorageBlock storageBlock=Provider.of<StorageBlock>(context,listen: false);
        UserBlock userBlock=Provider.of<UserBlock>(context,listen: false);
        print("resim siliniyor = "+mes.audio.ref);
        await storageBlock.deleteAudio(userBlock.user.uid,mes.audio.ref);
    }
  }
  Future<void> _deleteMessageFile(ChatMessage mes,BuildContext context)async{
    if(mes.file!=null){
        StorageBlock storageBlock=Provider.of<StorageBlock>(context,listen: false);
        UserBlock userBlock=Provider.of<UserBlock>(context,listen: false);
        
          print("dosya siliniyor = "+mes.file.ref);
          await storageBlock.deleteFile(userBlock.user.uid,mes.file.ref);
        
    }
  }

  Future<void> addMessage(
      MyUser sender, MyUser receiver, bool noMessage, ChatMessage mesaj) async {
    String docId = getDoc(sender.uid, receiver.uid);
    await updateChat(noMessage, sender, receiver, mesaj);
    await messagesColReference(docId).add(mesaj.toMap());
  }

  Stream<QuerySnapshot> getMessagesStream(String myUid) {
    return lastMessagesReference.doc(myUid).collection("messages").snapshots();
  }

  Future<void> setChatCard(String myUid, String receiverUid, Chat chat) async {
    await lastMessagesReference
        .doc(myUid)
        .collection("messages")
        .doc(receiverUid)
        .set(chat.toMap());
  }

  Future<void> updateChatCard(
      String myUid, String receiverUid, Chat chat) async {
    await lastMessagesReference
        .doc(myUid)
        .collection("messages")
        .doc(receiverUid)
        .set(chat.toMap(), SetOptions(merge: true));
  }

  Future<void> updateChat(
      bool noMessage, MyUser my, MyUser rec, ChatMessage message) async {
    String myMesaj;
    String recMesaj;
    int time = DateTime.now().millisecondsSinceEpoch;
    if (message.text != null) {
      if (message.text.isNotEmpty) {
        myMesaj = message.text;
        recMesaj = message.text;
      } else {
        myMesaj = getMesajFromType(message.messageType);
        recMesaj = getMesajFromType(message.messageType, isRec: true, my: my);
      }
    } else {
      myMesaj = getMesajFromType(message.messageType);
      recMesaj = getMesajFromType(message.messageType, isRec: true, my: my);
    }
    if (noMessage) {
      await setChatCard(
          my.uid,
          rec.uid,
          Chat(
              lastMessage: myMesaj,
              name: rec.displayName,
              image: rec.photoURL,
              time: time,
              senderUid: my.uid,
              rUid: rec.uid));
      await setChatCard(
          rec.uid,
          my.uid,
          Chat(
              lastMessage: recMesaj,
              name: my.displayName,
              image: my.photoURL,
              time: time,
              senderUid: my.uid,
              rUid: rec.uid));
    } else {
      await updateChatCard(
          my.uid,
          rec.uid,
          Chat(
              lastMessage: myMesaj,
              name: rec.displayName,
              image: rec.photoURL,
              time: time,
              senderUid: my.uid,
              rUid: rec.uid));
      await updateChatCard(
        rec.uid,
        my.uid,
        Chat(
          lastMessage: recMesaj,
          name: my.displayName,
          image: my.photoURL,
          time: time,
          rUid: rec.uid,
          senderUid: my.uid,
        ),
      );
    }
  }

  String getMesajFromType(ChatMessageType type, {MyUser my, bool isRec=false}) {
    switch (type) {
      case ChatMessageType.image:
        return isRec
            ? "${my.displayName} size bir resim gönderdi."
            : "resim 📷";
        break;
      case ChatMessageType.audio:
        return isRec ? "${my.displayName} size bir ses gönderdi." : "ses";
        break;
      case ChatMessageType.file:
        return isRec ? "${my.displayName} size bir dosya gönderdi." : "dosya";
        break;
      default:
        return isRec ? "${my.displayName} size bir video gönderdi." : "video";
    }
  }

  String getDoc(String uid1, String uid2) {
    List<String> uids = [uid1, uid2];
    uids.sort();
    return uids.join("_");
  }

  void dispose() {
    lastMessagesStream.close();
    lastMessagesSubscription.cancel();
  }
}
/*

if (widget.noMessage) {

                        await messagesBlock.setChatCard(
                            userBlock.user.uid,
                            widget.rUid,
                            Chat(
                                lastMessage: mesaj,
                                name: rec.displayName,
                                image: rec.photoURL,
                                time: time,
                                senderUid: my.uid,
                                rUid: rec.uid));
                        await messagesBlock.setChatCard(
                            widget.rUid,
                            userBlock.user.uid,
                            Chat(
                                lastMessage: mesaj,
                                name: my.displayName,
                                image: my.photoURL,
                                time: time,
                                senderUid: my.uid,
                                rUid: rec.uid));
                      } else {
                        
                        await messagesBlock.updateChatCard(
                            userBlock.user.uid,
                            widget.rUid,
                            Chat(
                                lastMessage: mesaj,
                                name: rec.displayName,
                                image: rec.photoURL,
                                time: time,
                                senderUid: my.uid,
                                rUid: rec.uid));
                        await messagesBlock.updateChatCard(
                          widget.rUid,
                          userBlock.user.uid,
                          Chat(
                            lastMessage: mesaj,
                            name: my.displayName,
                            image: my.photoURL,
                            time: time,
                            rUid: rec.uid,
                            senderUid: my.uid,
                          ),
                        );
                      }


*/
