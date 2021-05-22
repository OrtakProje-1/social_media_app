import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/database/firebase_yardimci.dart';
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

  clearData(){
    lastMessagesStream.add([]);
    lastMessagesSubscription?.cancel();
  }

  Future<void> fetchLastMessages(String uid) async {
   lastMessagesSubscription= getMessagesStream(uid).listen((event) {
      List<Chat> lastMessages =
          event.docs.map((e) => Chat.fromMap(e.data()).copyWith(docRef:e.reference)).toList();
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

  Future<void> deleteMessage(QueryDocumentSnapshot doc) async {
    await doc.reference.set({
      "text": "Bu mesaj silindi...",
      "isRemoved":true,
    }, SetOptions(merge: true));
  }

  Future<void> addMessage(String docId, ChatMessage mesaj) async {
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
