import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/my_user.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';
import 'package:social_media_app/providers/usersBlock.dart';

class GetDatas{

  static GetDatas _instance;
  
  factory GetDatas(){
    if(_instance==null){
      GetDatas._();
      return _instance;
    }
    return _instance;
  }

  GetDatas._(){
    _instance=this;
  }

  Future<void> getAllDatas(BuildContext context,String uid)async{
    ProfileBlock profileBlock=context.read<ProfileBlock>();
    UsersBlock usersBlock=context.read<UsersBlock>();
    PostsBlock postsBlock=context.read<PostsBlock>();
    NotificationBlock notificationBlock=NotificationBlock();

    await profileBlock.fetchDatas(uid);
    await postsBlock.fetchPosts(profileBlock.friendsUid.valueWrapper.value);
    notificationBlock.fetchNotifications(uid);
  }

}