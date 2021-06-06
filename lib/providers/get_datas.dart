

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/messagesBlock.dart';
import 'package:social_media_app/providers/notificationBlock.dart';
import 'package:social_media_app/providers/postsBlock.dart';
import 'package:social_media_app/providers/profileBlock.dart';

class GetDatas{

  static GetDatas? _instance;
  
  factory GetDatas(){
    if(_instance==null){
      GetDatas._();
      return _instance!;
    }
    return _instance!;
  }

  GetDatas._(){
    _instance=this;
  }

  Future<void> getAllDatas(BuildContext context,String uid,{bool isSignOut=false})async{
    ProfileBlock profileBlock=context.read<ProfileBlock>();
    PostsBlock postsBlock=context.read<PostsBlock>();
    NotificationBlock notificationBlock=NotificationBlock();
    MessagesBlock messagesBlock=context.read<MessagesBlock>();
    if(isSignOut) getClearAllDatas(profileBlock,postsBlock,notificationBlock,messagesBlock);
    await messagesBlock.fetchLastMessages(uid);
    await profileBlock.fetchDatas(uid);
    await postsBlock.fetchPosts(profileBlock.friendsUid.valueWrapper!.value);
    await notificationBlock.fetchNotifications(uid);
  }

  void getClearAllDatas(ProfileBlock profileBlock,PostsBlock postsBlock,NotificationBlock notificationBlock,MessagesBlock messagesBlock){
    profileBlock.clearDatas();
    postsBlock.clearDatas();
    notificationBlock.clearDatas();
    messagesBlock.clearData();
  }

  Future<void> getFetchPosts(PostsBlock postsBlock,List<String> friendsUid)async{
    await postsBlock.fetchPosts(friendsUid);
  }

}