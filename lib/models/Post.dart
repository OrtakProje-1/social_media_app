
class Post{
  String msg;
  String userName;
  String userPhotoUrl;
  List<String> likes;
  String postTime;
  List<String> images;
  List<String> savedPostCount;
  String audio;
  String video;
  String senderUid;
  Post({this.msg="",this.likes,this.postTime,this.savedPostCount,this.userName,this.userPhotoUrl,this.images,this.senderUid});

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
   if(msg!=null) map["message"]=msg;
    map["userName"]=userName;
    map["userPhotoUrl"]=userPhotoUrl;
  if(likes!=null)  map["likes"]=likes;
   if(images!=null) map["images"]=images;//!=null ? images.isNotEmpty ? images.map((e) =>{images.where((e1) =>e1==e):e}).toList(): null : null;
    // if(comments!=null&&comments.length>1){
    //   map["comments"]=comments.map((e) =>e.toMap()).toList();
    // }
    map["postTime"]=postTime;
    map["senderUid"]=senderUid;
 // if(comments!=null)  map["comments"]=comments.isNotEmpty ? comments.map((e) =>e.toMap()).toList() : [];
  if(savedPostCount!=null)  map["savedPostCount"]=savedPostCount;
    return map;
  }

  Post.fromMap(Map<String,dynamic> map){
    this.likes=(map["likes"] as List<dynamic>)?.map((e) =>e.toString())?.toList()??[];
    this.msg=map["message"];
    this.postTime=map["postTime"];
    this.userName=map["userName"];
    this.userPhotoUrl=map["userPhotoUrl"];
    this.images=(map["images"] as List<dynamic>)?.map((e) => "$e")?.toList()??[];
    this.senderUid=map["senderUid"];
    this.savedPostCount=(map["savedPostCount"] as List<dynamic>)?.map((e) =>e.toString())?.toList()??[];
   // this.comments=(map["comments"]as List<dynamic>)?.map((e)=>Post.fromMap(e))?.toList()??[];
  }
}