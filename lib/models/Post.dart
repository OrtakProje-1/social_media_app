import 'package:social_media_app/models/media_reference.dart';

class Post{
  String? msg;
  String? userName;
  String? userPhotoUrl;
  List<String?>? likes;
  String? postTime;
  List<MediaReference>? images;
  List<String>? savedPostCount;
  MediaReference? audio;
  MediaReference? video;
  String? senderUid;
  Post({this.msg="",this.likes,this.postTime,this.savedPostCount,this.userName,this.userPhotoUrl,this.images,this.senderUid,this.audio,this.video});

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    if(msg!=null) map["message"]=msg;
    map["userName"]=userName;
    map["userPhotoUrl"]=userPhotoUrl;
    if(likes!=null)  map["likes"]=likes;
    if(images!=null) map["images"]=images!.map((e) => e.toMap()).toList(); //!=null ? images.isNotEmpty ? images.map((e) =>{images.where((e1) =>e1==e):e}).toList(): null : null;
    if(audio!=null) map["audio"] = audio!.toMap();
    if(video!=null) map["video"] = video!.toMap();
    map["postTime"]=postTime;
    map["senderUid"]=senderUid;
    if(savedPostCount!=null)  map["savedPostCount"]=savedPostCount;
    return map;
  }

  Post.fromMap(Map<String,dynamic> map){
    this.likes=(map["likes"] as List<dynamic>?)?.map((e) =>e.toString()).toList()??[];
    this.msg=map["message"];
    this.postTime=map["postTime"];
    this.userName=map["userName"];
    this.userPhotoUrl=map["userPhotoUrl"];
    this.images=(map["images"] as List<dynamic>?)?.map((e) => MediaReference.fromMap(e)).toList()??[];
    this.senderUid=map["senderUid"];
    this.savedPostCount=(map["savedPostCount"] as List<dynamic>?)?.map((e) =>e.toString()).toList()??[];
    this.video= (map["video"]!=null) ? MediaReference.fromMap(map["video"]) : null;
    this.audio= (map["audio"]!=null) ? MediaReference.fromMap(map["audio"]) : null;
  }
}