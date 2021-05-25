

class NSender{
  String? name;
  String? photoURL;
  String? uid;
  NSender({this.name="",this.photoURL,this.uid});
  NSender.fromMap(Map<String,dynamic>map){
    this.name=map["displayName"];
    this.photoURL=map["photoURL"];
    this.uid=map["uid"];
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    map["displayName"]=this.name;
    map["photoURL"]=this.photoURL;
    map["uid"]=this.uid;
    return map;
  }
}