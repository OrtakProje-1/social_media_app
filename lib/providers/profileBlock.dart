

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/database/firebase_yardimci.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_receiver.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';

class ProfileBlock{
  ProfileBlock(){
    _firestore=FirebaseYardimci().firestore;
    _notificationBlock=NotificationBlock();
    init();
  }

  void init()async{
    friendsUid=BehaviorSubject.seeded([]);
    friends=BehaviorSubject.seeded([]);
    friendRequests=BehaviorSubject.seeded([]);
  }

  late NotificationBlock _notificationBlock;
  FirebaseFirestore? _firestore;

  late BehaviorSubject<List<MyUser>> friendRequests;
  BehaviorSubject<List<MyUser>>? friends;
  BehaviorSubject<List<String?>>? friendsUid;
  
  Stream<QuerySnapshot> get query=> _firestore!.collection("Users").snapshots();
  
  Stream<DocumentSnapshot>  streamQueryFromUid(String uid)=>_firestore!.collection("Users").doc(uid).snapshots();
  DocumentReference  queryFromUid(String? uid)=>_firestore!.collection("Users").doc(uid);
  
  Stream<QuerySnapshot> streamNotification(String uid)=>queryFromUid(uid).collection("notifications").orderBy("nTime",descending: true).snapshots();
  CollectionReference notification(String uid)=>queryFromUid(uid).collection("notifications");
  
  Stream<QuerySnapshot> streamFriends(String uid)=>queryFromUid(uid).collection("friends").snapshots();
  CollectionReference friendsCollection(String? uid)=>queryFromUid(uid).collection("friends");

  Stream<QuerySnapshot> streamFriendRequest(String uid)=>queryFromUid(uid).collection("friend_request").snapshots();
  CollectionReference friendRequest(String? uid)=>queryFromUid(uid).collection("friend_request");

  
  Future<void> updateUserisOnline(String uid,bool isOnline)async{
    await _firestore!.collection("Users").doc(uid).update({"isOnline":isOnline});
  }

  Future<void> sendFriendshipRequest({required MyUser friend,required MyUser sender})async{
    MyNotification notification=MyNotification(
      friend: sender,
      nMessage: "${sender.displayName} size arkadaşlık isteği göderdi.",
      nReceiver: NReceiver(
        rToken: friend.token,
        rUid: friend.uid
      ),
      nTime: DateTime.now().millisecondsSinceEpoch.toString(),
      nType: NType.FRIEND,
      nSender: NSender(
        name: sender.displayName,
        photoURL: sender.photoURL,
        uid: sender.uid
      ),
    );
    await _addMyFriendRequest(sender,friend);
    await _notificationBlock.addNotification(friend.uid,notification);
  }

  Future<void> _addMyFriendRequest(MyUser my,MyUser friend)async{
   await friendRequest(my.uid).doc(friend.uid).set(friend.toMap());
   await updateFriendRequest(friend);
  }

  Future<void> updateFriendRequest(MyUser newFriend)async{
    List<MyUser> fReq= friendRequests.value!;
    if(!fReq.any((e) =>e.uid==newFriend.uid)){
      fReq.add(newFriend);
      friendRequests.add(fReq);
    }
  }

  Future<void> addFriend(MyUser me,MyUser friend)async{
    await _notificationBlock.addNotification(friend.uid,MyNotification(
      friend: me,
      nMessage: "${me.displayName} arkadaşlık isteğinizi kabul etti.",
      nReceiver: NReceiver(
        rToken:friend.token,
        rUid: friend.uid
      ),
      nSender: NSender(
        name: me.displayName,
        photoURL: me.photoURL,
        uid: me.uid
      ),
      nTime: DateTime.now().millisecondsSinceEpoch.toString(),
      nType: NType.COMMENT,
    ));
    await friendsCollection(me.uid).doc(friend.uid).set(friend.toMap());
    await friendsCollection(friend.uid).doc(me.uid).set(me.toMap());
    await deleteRequest(me,friend);
    await getAllFriendsUid(me.uid);
  }

  Future<void> deleteRequest(MyUser me,MyUser friend)async{
    try {
      await queryFromUid(friend.uid).collection("friend_request").doc(me.uid).delete();
    } on Exception catch (e) {
      print("istek silinemedi");
    }
  }

  Future<void> getAllFriendsUid(String? uid)async{
    QuerySnapshot query= await friendsCollection(uid).get();
    List<String?> uids= query.docs.map((e) =>e.id).toList();
    uids.add(uid);
    friendsUid!.add(uids);
  }

  bool isRequest(String? uid){
    return friendRequests.value!.any((e) =>e.uid==uid);
  }

  bool isFriend(String? uid){
    return friends!.value!.any((e) =>e.uid==uid);
  }

  Future<void> fetchDatas(String uid)async{
    await getAllFriendsUid(uid);
    QuerySnapshot friendRequestsCollections= await friendRequest(uid).get();
    QuerySnapshot friendCollections= await friendsCollection(uid).get();

    List<MyUser> myFriendRequests= friendRequestsCollections.docs.map((e) =>MyUser.fromMap(e.data())).toList();
    List<MyUser> myFriends= friendCollections.docs.map((e) =>MyUser.fromMap(e.data())).toList();

    friends!.add(myFriends);
    friendRequests.add(myFriendRequests);
  }

  void clearDatas(){
    friendRequests.add([]);
    friends!.add([]);
    friendsUid!.add([]);
  }

  void dispose(){
    friends!.close();
    friendsUid!.close();
    friendRequests.close();
  }

}