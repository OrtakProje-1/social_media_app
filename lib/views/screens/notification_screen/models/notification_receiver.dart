class NReceiver{
  
  String rToken;
  String rUid;
  NReceiver({this.rToken="",this.rUid});

  NReceiver.fromMap(Map<String,dynamic>map){
    this.rToken=map["rToken"];
    this.rUid=map["rUid"];
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    map["rToken"]=this.rToken;
    map["rUid"]=this.rUid;
    return map;
  }
}