import 'dart:io';

import 'package:crypton/crypton.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class CryptoBlock {
  static CryptoBlock? _instance;

  Box<String>? keys;

  RSAPrivateKey? _privateKey;

  RSAKeypair get keypair => RSAKeypair(_privateKey!);

  factory CryptoBlock() {
    if (_instance == null) {
      CryptoBlock._();
      return _instance!;
    } else {
      return _instance!;
    }
  }

  CryptoBlock._() {
    print("hiveblock init");
    _instance = this;
  }

  String decrypt(String cyptedMessage){
    try {
      return getPrivateKey().decrypt(cyptedMessage);
    } catch (e) {
      return cyptedMessage;
    }
  }

  Future<RSAKeypair> getKeys(String userUid)async{
    print("getKeys");
    if(keys==null){
      print("keys==null");
      await initDb();
    }
    if(isThereKeys(userUid)){
      _setKey(userUid);
    }else{
      await _setNewKeys(userUid);
    }
    return keypair;
  }

  _setKey(String uid){
    _privateKey=RSAPrivateKey.fromString(keys!.get(uid)!);
  }

  Future<void> _setNewKeys(String uid) async {
    RSAKeypair keypair = RSAKeypair.fromRandom();
    _privateKey = keypair.privateKey;
    await _saveKey(uid);
  }

  Future<void> _saveKey(String uid)async{
    await keys!.put(uid,keypair.privateKey.toString());
  }

  bool isThereKeys(String uid) {
    String? privateKey = keys!.get(uid);
    return privateKey != null;
  }

  RSAPublicKey getPublicKey() {
    return getPrivateKey().publicKey;
  }

  RSAPrivateKey getPrivateKey() {
    return keypair.privateKey;
  }

  Future<void> deleteKeys() async {
    await keys!.clear();
  }

  Future<void> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    keys = await Hive.openBox<String>("keys");
    print("keys oluştu");
  }
}
