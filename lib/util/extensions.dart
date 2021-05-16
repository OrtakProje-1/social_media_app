import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

extension AnimatedWidgetExtension on Widget {
  fadeInList(int index, bool isVertical) {
    double offset = 50.0;
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 900),
      child: SlideAnimation(
        horizontalOffset: isVertical ? 0.0 : offset,
        verticalOffset: !isVertical ? 0.0 : offset,
        child: FadeInAnimation(
          child: this,
        ),
      ),
    );
  }
}

extension UserExtension on User{
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    map["displayName"]=this.displayName;
    map["email"]=this.email;
    map["emailVerified"]=this.emailVerified;
    map["isAnonymous"]=this.isAnonymous;
    map["metadata"]=this.metadata.toMap();
    map["phoneNumber"]=this.phoneNumber;
    map["photoURL"]=this.photoURL;
    map["providerData"]=this.providerData.map((e) =>e.toMap()).toList();
    map["refreshToke"]=this.refreshToken;
    map["tenantId"]=this.tenantId;
    map["uid"]=this.uid;
    return map;
  }
}

extension UserProviderData on UserInfo{
   Map<String,String> toMap(){
    Map<String,String> map=Map<String,String>();
    map["displayName"]=this.displayName;
    map["email"]=this.email;
    map["phoneNumber"]=this.phoneNumber;
    map["photoURL"]=this.photoURL;
    map["uid"]=this.uid;
    return map;
  }
}

extension UserMetaData on UserMetadata{
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map=Map<String,dynamic>();
    map["creationTime"]=this.creationTime?.millisecondsSinceEpoch;
    map["lastSignInTime"]=this.lastSignInTime?.millisecondsSinceEpoch;
    return map;
  }
}
