

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification.dart';

class NotificationBlock{
  static NotificationBlock? _nInstance;
  late FirebaseFirestore _instance;
  late BehaviorSubject<List<MyNotification>> notifications;

  factory NotificationBlock(){
    return _nInstance ??= NotificationBlock._();
  }

  NotificationBlock._(){
    _nInstance=this;
    notifications=BehaviorSubject.seeded([]);
    _instance=FirebaseFirestore.instance;
  }

  Future<QuerySnapshot> _getNotifications(String uid)async{
     return await _instance.collection("Users").doc(uid).collection("notifications").get();
  }

  Stream<QuerySnapshot> _getNotificationsStream(String uid){
     return  _instance.collection("Users").doc(uid).collection("notifications").snapshots();
  }

  Future<void> addNotification(String? uid,MyNotification notification)async{
   await _instance.collection("Users").doc(uid).collection("notifications").doc(notification.nSender!.uid!+"_"+notification.nTime!).set(notification.toMap());
  }
  
  Future<void> deleteNotification(String? uid,MyNotification notification)async{
   await _instance.collection("Users").doc(uid).collection("notifications").doc(notification.nSender!.uid!+"_"+notification.nTime!).delete();
  }

  Future<void> updateNotification(String? uid,MyNotification newNotification)async{
   await _instance.collection("Users").doc(uid).collection("notifications").doc(newNotification.nSender!.uid!+"_"+newNotification.nTime!).set(newNotification.toMap());
  }

  Future<void> fetchNotifications(String uid)async{
    QuerySnapshot query=await _getNotifications(uid);
    List<MyNotification> myNotifications= query.docs.map((e) =>MyNotification.fromMap(e.data())).toList();
    notifications.add(myNotifications);
    _getNotificationsStream(uid).listen((event){
      print("notification reload");
      List<MyNotification> myNotifications2= event.docs.map((e) =>MyNotification.fromMap(e.data())).toList();
    notifications.add(myNotifications2);
    });
  }

  void clearDatas(){
    notifications.add([]);
  }

  void dispose(){
    notifications.close();
  }

}