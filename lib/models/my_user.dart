import 'package:social_media_app/util/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String? displayName,
      email,
      phoneNumber,
      photoURL,
      refreshToken,
      tenantId,
      uid,
      token;
  bool? emailVerified, isAnonymous, isOnline;
  UserMetadata? metadata;
  List<UserInfo>? providerData;

  MyUser(
      {
      required this.token,
      this.displayName,
      this.email,
      this.emailVerified,
      this.isAnonymous,
      this.metadata,
      this.phoneNumber,
      this.photoURL,
      this.providerData,
      this.refreshToken,
      this.tenantId,
      this.isOnline,
      this.uid});

  MyUser.fromMap(Map<String, dynamic> map) {
    this.displayName = map["displayName"];
    this.email = map["email"];
    this.emailVerified = map["emailVerified"];
    this.isAnonymous = map["isAnonymous"];
    this.metadata = UserMetadata(map["metadata"]["creationTime"], map["metadata"]["lastSignInTime"]);
    this.phoneNumber = map["phoneNumber"];
    this.photoURL = map["photoURL"];
    this.providerData = (map["providerData"] as List<dynamic>).map((e) {
      Map<String, dynamic> map = e;
      Map<String, String> newMap = Map<String, String>();
      map.forEach((key, value) {
        newMap[key] = value.toString();
      });
      return UserInfo(newMap);
    }).toList();
    this.token = map["token"];
    this.refreshToken = map["refreshToken"];
    this.tenantId = map["tenantId"];
    this.uid = map["uid"];
    this.isOnline = map["isOnline"] ?? false;
  }

  MyUser.fromUser(User user, {bool isOnline = true,required String? token}) {
    this.displayName = user.displayName;
    this.email = user.email;
    this.phoneNumber = user.phoneNumber;
    this.photoURL = user.photoURL;
    this.refreshToken = user.refreshToken;
    this.tenantId = user.tenantId;
    this.uid = user.uid;
    this.emailVerified = user.emailVerified;
    this.isAnonymous = user.isAnonymous;
    this.metadata = user.metadata;
    this.providerData = user.providerData;
    this.isOnline = isOnline;
    this.token = token;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["displayName"] = this.displayName;
    map["email"] = this.email;
    map["emailVerified"] = this.emailVerified;
    map["isAnonymous"] = this.isAnonymous;
    map["metadata"] = this.metadata?.toMap();
    map["phoneNumber"] = this.phoneNumber;
    map["photoURL"] = this.photoURL;
    map["providerData"] = this.providerData?.map((e) => e.toMap()).toList();
    map["refreshToken"] = this.refreshToken;
    map["tenantId"] = this.tenantId;
    map["uid"] = this.uid;
    map["token"] = this.token;
    map["isOnline"] = this.isOnline ?? false;
    return map;
  }

  @override
  String toString() {
    return '$MyUser('
        'displayName: $displayName, '
        'email: $email, '
        'emailVerified: $emailVerified, '
        'isAnonymous: $isAnonymous, '
        'metadata: $metadata, '
        'phoneNumber: $phoneNumber, '
        'photoURL: $photoURL, '
        'providerData, $providerData, '
        'refreshToken: $refreshToken, '
        'tenantId: $tenantId, '
        'uid: $uid)';
  }
}
