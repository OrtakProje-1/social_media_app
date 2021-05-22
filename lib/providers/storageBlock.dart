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

  Reference get audiosRef {
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

  Future<String> uploadAudio({File file, String userUid, int index,String timeStamp,String ext})async{
    
    UploadTask task = audiosRef
        .child(userUid)
        .child("$timeStamp-$index.$ext")
        .putFile(file,SettableMetadata(contentType: 'audio/$ext'));
    await task.whenComplete(() => null);
    return await task.snapshot.ref.getDownloadURL();
  }

  Future<String> uploadVideo({File file, String userUid, int index,String timeStamp,String ext})async{
    
    UploadTask task = videosRef
        .child(userUid)
        .child("$timeStamp-$index.$ext")
        .putFile(file,SettableMetadata(contentType: 'video/$ext'));
    await task.whenComplete(() => null);
    return await task.snapshot.ref.getDownloadURL();
  }

  static String fileExt(String name){
    return name.split(".").last;
  }

  void dispose() {}
}
