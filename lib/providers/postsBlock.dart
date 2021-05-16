import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_receiver.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';
import 'package:social_media_app/views/widgets/post_item.dart';

class PostsBlock {
  PostsBlock() {
    _instance = FirebaseFirestore.instance;
    _notificationBlock = NotificationBlock();
    posts=BehaviorSubject.seeded([]);
  }

  FirebaseFirestore _instance;
  NotificationBlock _notificationBlock;
  BehaviorSubject<List<Post>> posts;

  CollectionReference get postsReference => _instance.collection("Posts");
  Stream<QuerySnapshot> get streamPosts => _instance
      .collection("Posts")
      .orderBy("postTime", descending: true)
      .snapshots(); //orderBy("postTime",descending:false);

  Future<QuerySnapshot> getFriendsPost(List<String> uids)async{
    return await postsReference.where("senderUid",whereIn: uids ).get();
  }

  Stream<QuerySnapshot> getStreamFriendsPost(List<String> uids){
    return postsReference.where("senderUid",whereIn: uids ).snapshots();
  }

  DocumentReference postReference(Post post) {
    return postsReference.doc(post.senderUid + "_" + post.postTime);
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

  Future<bool> updatePost(Post updatedPost) async {
    await _instance
        .collection("Posts")
        .doc("${updatedPost.senderUid}_${updatedPost.postTime}")
        .update(updatedPost.toMap());
    return true;
  }

  Future<void> addComment(Post comment, Post parentPost,UsersBlock usersBlock) async {
    MyUser receiver=usersBlock.getUserFromUid(parentPost.senderUid);
    await postReference(parentPost)
        .collection("comments")
        .doc(comment.senderUid + "_" + comment.postTime)
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

  Future<void> updateLike(bool newValue, Post post,String likerUid,UsersBlock usersBlock) async {
    List<String> updatedLikes = post.likes ?? [];
    MyUser liker=usersBlock.getUserFromUid(likerUid);
    MyUser receiverUser=usersBlock.getUserFromUid(post.senderUid);
    if (newValue) {
      updatedLikes.add(liker.uid);
     /*if(post.senderUid!=liker.uid)*/ await _notificationBlock.addNotification(
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
                rToken: receiverUser.token,
                rUid: receiverUser.uid,
              ),
              nTime: DateTime.now().millisecondsSinceEpoch.toString(),
              nType: NType.LIKE));
    } else {
      updatedLikes.remove(liker.uid);
    }
    updatePost(post..likes = updatedLikes);
  }

  Future<bool> deletePost(Post deletePost) async {
    try {
      await postsReference
          .doc(deletePost.senderUid + "_" + deletePost.postTime)
          .delete();
    } catch (e) {
      print("Post silmede hata oluştu hata= " + e.toString());
      return false;
    }
    return true;
  }

  Future<void> fetchPosts(List<String> uids)async{
    QuerySnapshot query= await getFriendsPost(uids);
    List<Post> myPost= query.docs.map((e) =>Post.fromMap(e.data())).toList();
    posts.add(myPost);
  }

  void dispose(){
    posts.close();
  }
}
