

import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/models/media_reference.dart';

class StorageBlock {
  StorageBlock() {
    _storage = FirebaseStorage.instance;
    _reference = _storage.ref();
  }

  Reference? _reference;
  late FirebaseStorage _storage;

  Reference? get reference => _reference;

  Reference get imagesRef {
    return _storage.ref().child("images");
  }

  Reference get videosRef {
    return _storage.ref().child("videos");
  }

  Reference get audiosRef {
    return _storage.ref().child("sounds");
  }

  Reference get filesRef {
    return _storage.ref().child("files");
  }

  Future<MediaReference> uploadImage({required File file, required String userUid, int? index,String? timeStamp,String? ext})async{
    String ref="$timeStamp-$index.$ext";
    UploadTask task = imagesRef
        .child(userUid)
        .child(ref)
        .putFile(file,SettableMetadata(contentType: 'image/$ext'));
    await task.whenComplete(() => null);
    String downloadURL=await task.snapshot.ref.getDownloadURL();
    return MediaReference(downloadURL: downloadURL,ref: ref);
  }

  Future<MediaReference> uploadAudio({required File file, required String userUid, int? index,String? timeStamp,String? ext})async{
    String ref="$timeStamp-$index.$ext";
    UploadTask task = audiosRef
        .child(userUid)
        .child(ref)
        .putFile(file,SettableMetadata(contentType: 'audio/$ext'));
    await task.whenComplete(() => null);
    String downloadURL= await task.snapshot.ref.getDownloadURL();
    return MediaReference(ref:ref, downloadURL: downloadURL);
  }

  Future<MediaReference> uploadVideo({required File file, required String userUid, int? index,String? timeStamp,String? ext})async{
    String ref="$timeStamp-$index.$ext";
    UploadTask task = videosRef
        .child(userUid)
        .child("$timeStamp-$index.$ext")
        .putFile(file,SettableMetadata(contentType: 'video/$ext'));
    await task.whenComplete(() => null);
    String downloadURL= await task.snapshot.ref.getDownloadURL();
    return MediaReference(ref:ref, downloadURL: downloadURL);
  }

  Future<MediaReference> uploadFile({required File file, required String userUid, int? index,String? timeStamp,String? ext})async{
    String ref="$timeStamp-$index.$ext";
    UploadTask task = filesRef
        .child(userUid)
        .child("$timeStamp-$index.$ext")
        .putFile(file,SettableMetadata(contentType: 'text/$ext'));
    await task.whenComplete(() => null);
    String downloadURL= await task.snapshot.ref.getDownloadURL();
    return MediaReference(ref:ref, downloadURL: downloadURL);
  }

  static String fileExt(String name){
    return name.split(".").last;
  }

  Future<void> deleteImage(String uid,String child)async{
    await imagesRef.child(uid).child(child).delete();
  }
  Future<void> deleteVideo(String uid,String child)async{
    await videosRef.child(uid).child(child).delete();
  }
  Future<void> deleteAudio(String uid,String child)async{
    await audiosRef.child(uid).child(child).delete();
  }
  Future<void> deleteFile(String uid,String child)async{
    await filesRef.child(uid).child(child).delete();
  }

  void dispose() {}
}
