

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/database/firebase_yardimci.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/blocked_details.dart';
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
    blockedUsers= BehaviorSubject.seeded([]);
  }

  late NotificationBlock _notificationBlock;
  FirebaseFirestore? _firestore;

  StreamSubscription<QuerySnapshot>? friendsSubscription;
  StreamSubscription<QuerySnapshot>? blockedUserSubscription;

  late BehaviorSubject<List<MyUser>> friendRequests;
  late BehaviorSubject<List<MyUser>> friends;
  late BehaviorSubject<List<String>> friendsUid;
  late BehaviorSubject<List<BlockedDetails>> blockedUsers;
  
  Stream<QuerySnapshot> get query=> _firestore!.collection("Users").snapshots();
  
  Stream<DocumentSnapshot>  streamQueryFromUid(String uid)=>_firestore!.collection("Users").doc(uid).snapshots();
  DocumentReference  queryFromUid(String? uid)=>_firestore!.collection("Users").doc(uid);
  
  Stream<QuerySnapshot> streamNotification(String uid)=>queryFromUid(uid).collection("notifications").orderBy("nTime",descending: true).snapshots();
  CollectionReference notification(String uid)=>queryFromUid(uid).collection("notifications");
  
  Stream<QuerySnapshot> streamFriends(String uid)=>queryFromUid(uid).collection("friends").snapshots();
  CollectionReference friendsCollection(String? uid)=>queryFromUid(uid).collection("friends");

  Stream<QuerySnapshot> streamFriendRequest(String uid)=>queryFromUid(uid).collection("friend_request").snapshots();
  CollectionReference friendRequest(String? uid)=>queryFromUid(uid).collection("friend_request");
  
  Stream<QuerySnapshot> streamBlockedUsers(String uid)=>queryFromUid(uid).collection("blockedUsers").snapshots();
  CollectionReference blockedUsersCollection(String? uid)=>queryFromUid(uid).collection("blockedUsers");

  
  Future<void> updateUserisOnline(String? uid,bool isOnline)async{
   if(uid!=null) await _firestore!.collection("Users").doc(uid).update({"isOnline":isOnline});
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
  }

  Future<void> deleteFriend(String myUid,String removeFriendUid)async{
    await friendsCollection(myUid).doc(removeFriendUid).delete();
    await friendsCollection(removeFriendUid).doc(myUid).delete();
  }

  Future<void> deleteRequest(MyUser me,MyUser friend)async{
    try {
      await queryFromUid(friend.uid).collection("friend_request").doc(me.uid).delete();
    } on Exception catch (e) {
      print("istek silinemedi");
    }
  }

  Future<void> getAllFriendsUid(String? uid,List<MyUser> myFriends)async{
    List<String> uids= myFriends.map((e) =>e.uid!).toList();
    uids.add(uid!);
    friendsUid.add(uids);
  }

  bool isRequest(String? uid){
    return friendRequests.value!.any((e) =>e.uid==uid);
  }

  bool isFriend(String? uid){
    return friends.value!.any((e) =>e.uid==uid);
  }

  Future<void> fetchDatas(String uid)async{
    QuerySnapshot friendRequestsCollections= await friendRequest(uid).get();
    QuerySnapshot friendsCol= await friendsCollection(uid).get();
    List<MyUser> friendss= friendsCol.docs.map((e) =>MyUser.fromMap(e.data())).toList();
    friends.add(friendss);
    await getAllFriendsUid(uid,friendss);
    friendsSubscription= streamFriends(uid).listen((friendCollections)async{
      List<MyUser> myFriends= friendCollections.docs.map((e) =>MyUser.fromMap(e.data())).toList();
      friends.add(myFriends);
      await getAllFriendsUid(uid,myFriends);
    });

    List<MyUser> myFriendRequests= friendRequestsCollections.docs.map((e) =>MyUser.fromMap(e.data())).toList();
    friendRequests.add(myFriendRequests);
    await getBlockedUsers(uid);
  }

  Future<void> getBlockedUsers(String uid)async{
    blockedUserSubscription=streamBlockedUsers(uid).listen((e){
      List<BlockedDetails> usersUid=e.docs.map((e) =>BlockedDetails.fromMap(e.data())).toList();
      blockedUsers.add(usersUid);
    });
  }

  Future<void> addBookmark(Post post,String uid)async{
    await queryFromUid(uid).collection("bookmarks").doc(post.senderUid!+"_"+post.postTime!).set(post.toMap());
  }
  Future<void> removeBookmark(Post post,String uid)async{
    await queryFromUid(uid).collection("bookmarks").doc(post.senderUid!+"_"+post.postTime!).delete();
  }

  Future<void> changeBlockedUser(MyUser my,String blockedUid)async{
    if(!blockedUsers.value!.contains(blockedUid)){
     await addNewBlockedUser(my, blockedUid);
    }else{
     await deleteBlockedUser(my, blockedUid);
    }
  }

  Future<void> addNewBlockedUser(MyUser my,String blockedUid)async{
    await blockedUsersCollection(my.uid).doc(blockedUid).set(BlockedDetails(blockedTime: DateTime.now(),blockedUid: blockedUid,lastMessage:"").toMap());
  }

  Future<void> deleteBlockedUser(MyUser my,String deleteBlockedUid)async{
    await blockedUsersCollection(my.uid).doc(deleteBlockedUid).delete();
  }

  void clearDatas(){
    friendRequests.add([]);
    friends.add([]);
    friendsUid.add([]);
    blockedUsers.add([]);
    friendsSubscription?.cancel();
    blockedUserSubscription?.cancel();
  }

  void dispose(){
    blockedUsers.close();
    friends.close();
    friendsUid.close();
    friendRequests.close();
    friendsSubscription?.cancel();
  }

}