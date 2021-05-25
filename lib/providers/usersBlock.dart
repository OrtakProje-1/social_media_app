

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media_app/database/firebase_yardimci.dart';
import 'package:social_media_app/models/my_user.dart';

class UsersBlock{
  FirebaseFirestore? _firestore;
  BehaviorSubject<List<MyUser>> users=BehaviorSubject.seeded([]);
  StreamSubscription<QuerySnapshot>? _usersSubsricption;
  UsersBlock(){
    _firestore=FirebaseYardimci().firestore;
    _getUsers();
  }

  void _getUsers()async{
   _usersSubsricption= _firestore!.collection("Users").snapshots().listen((event){
      List<MyUser> newUsers=[];
      for(QueryDocumentSnapshot query in event.docs){
        newUsers.add(MyUser.fromMap(query.data()));
      }
        users.add(newUsers);
    });
    
  }

  void addUser(MyUser user)async{
    String? token=await FirebaseMessaging.instance.getToken();
    _firestore!.collection("Users").doc(user.uid).set((user..token=token).toMap());
  }
  void updateUser({required MyUser updatedUser}){
    _firestore!.collection("Users").doc(updatedUser.uid).update(updatedUser.toMap());
  }

  MyUser? getUserFromUid(String? uid){
   List<MyUser> snapshot= users.value!.where((element) => element.uid==uid).toList();
    if(snapshot.isNotEmpty){
      return snapshot.first;
    }else{
      return null;
    }
  }

  void dispose(){
    _usersSubsricption?.cancel();
  }
}