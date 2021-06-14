

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/util/data.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_receiver.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';
import 'package:social_media_app/views/widgets/post/post_item.dart';

class PostsBlock {
  PostsBlock() {
    _instance = FirebaseFirestore.instance;
    _notificationBlock = NotificationBlock();
    posts=BehaviorSubject.seeded([]);
  }

  late FirebaseFirestore _instance;
  late NotificationBlock _notificationBlock;
  BehaviorSubject<List<Post>>? posts;
  StreamSubscription? postStreamSubscription;

  CollectionReference get postsReference => _instance.collection("Posts");
  Stream<QuerySnapshot> get streamPosts => _instance
      .collection("Posts")
      .orderBy("postTime", descending: true)
      .snapshots(); //orderBy("postTime",descending:false);

  Future<QuerySnapshot> getFriendsPost(List<String>? friendsUid)async{
    return await postsReference.where("senderUid",whereIn: friendsUid! ).orderBy("postTime",descending: true).get();
  }

  Stream<QuerySnapshot> getStreamFriendsPost(List<String> uids){
    return postsReference.where("senderUid",whereIn: uids ).orderBy("postTime",descending: true).snapshots();
  }

  DocumentReference postReference(Post post) {
    return postsReference.doc(post.senderUid! + "_" + post.postTime!);
  }

  CollectionReference commentReference(Post post) {
    return postReference(post).collection("comments");
  }

  Stream<QuerySnapshot> commentsStream(Post post) {
    return commentReference(post).snapshots();
  }

  Future<bool> addPost(Post post) async {
    await _instance
        .collection("Posts")
        .doc("${post.senderUid}_${post.postTime}")
        .set(
          post.toMap(),
        );
    return true;
  }

  Future<void> updateBookmark(Post post,String uid,ProfileBlock profileBlock)async{
    List<String> bookmarks=post.savedPostCount??[];
    if(bookmarks.contains(uid)){
      bookmarks.remove(uid);
      profileBlock.removeBookmark(post, uid);
    }else{
      bookmarks.add(uid);
      profileBlock.addBookmark(post, uid);
    }
    await updatePost(post..savedPostCount=bookmarks);
  }

  Future<bool> updatePost(Post updatedPost) async {
    await _instance
        .collection("Posts")
        .doc("${updatedPost.senderUid}_${updatedPost.postTime}")
        .update(updatedPost.toMap());
    return true;
  }

  Future<void> addComment(Post comment, Post parentPost,UsersBlock usersBlock) async {
    MyUser receiver=usersBlock.getUserFromUid(parentPost.senderUid)!;
    await postReference(parentPost)
        .collection("comments")
        .doc(comment.senderUid! + "_" + comment.postTime!)
        .set(comment.toMap())
        .catchError((e) {
      print("addComment de hata oluştu");
    });
   // if(comment.senderUid!=parentPost.senderUid){
      MyNotification myNotification = MyNotification(
      nType: NType.COMMENT,
      post: parentPost,
      nMessage: "${comment.userName} gönderinize yorum yaptı",
      nTime: DateTime.now().millisecondsSinceEpoch.toString(),
      nSender: NSender(
          name: comment.userName,
          photoURL: comment.userPhotoUrl,
          uid: comment.senderUid),
      nReceiver: NReceiver(
        rToken: receiver.token,
        rUid: receiver.uid,
      ),
    );
    await _notificationBlock.addNotification(
        parentPost.senderUid, myNotification);
    //}
  }

  Future<void> updateLike(bool newValue, Post post,String? likerUid,UsersBlock usersBlock) async {
    List<String?> updatedLikes = post.likes ?? [];
    MyUser? liker=usersBlock.getUserFromUid(likerUid);
    MyUser? receiverUser=usersBlock.getUserFromUid(post.senderUid);
    if (newValue) {
      updatedLikes.add(liker!.uid);
     if(post.senderUid!=liker.uid) await _notificationBlock.addNotification(
          post.senderUid,
          MyNotification(
              nMessage: "${liker.displayName} sizin göderinizi beğendi.",
              post: post,
              nSender: NSender(
                name: liker.displayName,
                photoURL: liker.photoURL,
                uid: liker.uid,
              ),
              nReceiver: NReceiver(
                rToken: receiverUser!.token,
                rUid: receiverUser.uid,
              ),
              nTime: DateTime.now().millisecondsSinceEpoch.toString(),
              nType: NType.LIKE));
    } else {
      updatedLikes.remove(liker!.uid);
    }
    updatePost(post..likes = updatedLikes);
  }

  Future<bool> deletePost(Post deletePost) async {
    try {
      await postsReference
          .doc(deletePost.senderUid! + "_" + deletePost.postTime!)
          .delete();
      await deletePostMedia(deletePost);
    } catch (e) {
      print("Post silmede hata oluştu hata= " + e.toString());
      return false;
    }
    return true;
  }

  Future<void> deletePostMedia(Post deletedPost)async{
    if(deletedPost.images!=null){
      if(deletedPost.images!.isNotEmpty) deletedPostImages(deletedPost);
    }
    if(deletedPost.audio!=null){
       deletedPostAudio(deletedPost);
    }
    if(deletedPost.video!=null){
       deletedPostVideo(deletedPost);
    }
  }

  Future<void> deletedPostImages(Post post)async{}
  Future<void> deletedPostAudio(Post post)async{}
  Future<void> deletedPostVideo(Post post)async{}

  Future<void> fetchPosts(List<String>? friendsUid)async{
    QuerySnapshot query= await getFriendsPost(friendsUid);
    List<Post> myPost= query.docs.map((e) =>Post.fromMap(e.data())).toList();
    posts!.add(myPost);
    postStreamSubscription= getStreamFriendsPost(friendsUid!).listen((event){
      List<Post> newPosts= event.docs.map((e) =>Post.fromMap(e.data())).toList();
      posts!.add(newPosts);
    });
  }

  void clearDatas(){
    postStreamSubscription?.cancel();
    posts!.add([]);
  }

  void dispose(){
    posts?.close();
    postStreamSubscription?.cancel();
    posts!.close();
  }
}
