

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat {
  final String? name;
  final String? lastMessage;
  final String? image;
  final String? rUid;
  final String? senderUid;
  final int? time;
  final DocumentReference? docRef;
  Chat({
    required this.name,
    this.docRef,
    required this.senderUid,
    required this.lastMessage,
    required this.image,
    required this.rUid,
    required this.time,
  });

  Chat copyWith({
    String? name,
    String? rUid,
    String? senderUid,
    String? lastMessage,
    String? image,
    int? time,
    bool? isActive,
    int? unReadCount,
    DocumentReference? docRef,
  }) {

    return Chat(
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      image: image ?? this.image,
      time: time ?? this.time,
      rUid: rUid ?? this.rUid,
      docRef: docRef ?? this.docRef,
      senderUid: senderUid ?? this.senderUid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'image': image,
      'time': time,
      'rUid': rUid,
      'senderUid': senderUid,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      name: map['name'],
      lastMessage: map['lastMessage'],
      image: map['image'],
      time: map['time'],
      rUid: map['rUid'],
      senderUid: map['senderUid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(name: $name, lastMessage: $lastMessage, image: $image, time: $time, rUid:$rUid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Chat &&
      other.name == name &&
      other.lastMessage == lastMessage &&
      other.image == image &&
      other.rUid == rUid &&
      other.time == time;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      lastMessage.hashCode ^
      image.hashCode ^
      rUid.hashCode ^
      time.hashCode;
  }
}
