import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseYardimci{
  static FirebaseYardimci _instance;
  FirebaseFirestore _firestore;

  FirebaseFirestore get firestore=>_firestore;

  factory FirebaseYardimci(){
    if(_instance==null){
      FirebaseYardimci._init();
      return _instance;
    }else{
      return _instance;
    }
  }

  FirebaseYardimci._init(){
    _firestore=FirebaseFirestore.instance;
    _instance=this;
  }

  
}