

import 'package:social_media_app/models/Post.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/views/screens/notification_screen/enum/notification_type.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_receiver.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';

class MyNotification {
  String? nMessage;
  NType? nType;
  NSender? nSender;
  String? nTime;
  bool? isRead;
  Post? post;
  MyUser? friend;
  NReceiver? nReceiver;

  MyNotification(
      {this.isRead = false,
      this.nType,
      this.nTime,
      this.nSender,
      this.nMessage,
      this.friend,
      this.nReceiver,
      this.post});

  MyNotification.fromMap(Map<String, dynamic> map) {
    this.nMessage = map["nMessage"];
    this.nSender = NSender.fromMap(map["nSender"]);
    this.nTime = map["nTime"];
    this.nType = NType.values[map["nType"]];
    this.isRead = map["isRead"];
    this.post =map["post"] !=null ? Post.fromMap(map["post"]) : null;
    this.friend = map["friend"] != null ? MyUser.fromMap(map["friend"]) : null;
    this.nReceiver =map["nReceiver"]!=null ? NReceiver.fromMap(map["nReceiver"]) : null;
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["nMessage"] = this.nMessage;
    map["nSender"] = this.nSender!.toMap();
    map["nTime"] = this.nTime;
    map["nType"] = this.nType!.index;
    map["isRead"] = this.isRead;
  if(post!=null)  map["post"] = this.post!.toMap();
  if(friend!=null) map["friend"] = this.friend!.toMap();
   if(nReceiver!=null) map["nReceiver"] = this.nReceiver!.toMap();
    return map;
  }
}
