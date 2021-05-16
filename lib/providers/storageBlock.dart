import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageBlock {
  StorageBlock() {
    _storage = FirebaseStorage.instance;
    _reference = _storage.ref();
  }

  Reference _reference;
  FirebaseStorage _storage;

  Reference get reference => _reference;

  Reference get imagesRef {
    return _storage.ref().child("images");
  }

  Reference get videosRef {
    return _storage.ref().child("videos");
  }

  Reference get soundsRef {
    return _storage.ref().child("sounds");
  }

  Future<String> uploadImage({File file, String userUid, int index,String timeStamp,String ext})async{
    
    UploadTask task = imagesRef
        .child(userUid)
        .child("$timeStamp-$index.$ext")
        .putFile(file,SettableMetadata(contentType: 'image/$ext'));
    await task.whenComplete(() => null);
    return await task.snapshot.ref.getDownloadURL();
  }

  static String fileExt(String name){
    return name.split(".").last;
  }

  void dispose() {}
}
