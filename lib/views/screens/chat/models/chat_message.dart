

import 'dart:convert';

import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/util/enum.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_receiver.dart';
import 'package:social_media_app/views/screens/notification_screen/models/notification_sender.dart';

class ChatMessage {
  final String? recCryptedText;
  final String? senderCryptedText;
  final ChatMessageType? messageType;
  final MessageStatus? messageStatus;
  final NSender? sender;
  final NReceiver? receiver;
  final int? messageTime;
  final bool? isRemoved;
  final List<MediaReference?>? images;
  final MediaReference? audio;
  final MediaReference? video;
  final MediaReference? file;

  ChatMessage({
    this.recCryptedText,
    this.senderCryptedText,
    this.messageTime,
    this.messageType,
    this.messageStatus,
    this.sender,
    this.receiver,
    this.isRemoved,
    this.audio,
    this.images,
    this.video,
    this.file
  });


  ChatMessage copyWith({
    String? recCryptedText,
    String? senderCryptedText,
    ChatMessageType? messageType,
    MessageStatus? messageStatus,
    NSender? sender,
    NReceiver? receiver,
    int? messageTime,
    bool? isRemoved,
    List<MediaReference>? images,
    MediaReference? video,
    MediaReference? audio,
    MediaReference? file,
  }) {
    return ChatMessage(
      recCryptedText: recCryptedText ?? this.recCryptedText,
      messageType: messageType ?? this.messageType,
      messageStatus: messageStatus ?? this.messageStatus,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      messageTime: messageTime ?? this.messageTime,
      isRemoved: isRemoved ?? this.isRemoved,
      audio: audio ?? this.audio,
      images: images ?? this.images,
      video: video ?? this.video,
      file: file ?? this.file,
      senderCryptedText: senderCryptedText ?? this.senderCryptedText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recCryptedText': recCryptedText,
      'senderCryptedText': senderCryptedText,
      'messageType': messageType!.index,
      'messageStatus': messageStatus!.index,
      'sender': sender!.toMap(),
      'messageTime': messageTime,
      'isRemoved': isRemoved,
      if(receiver!=null) 'receiver':receiver!.toMap(),
      if(audio!=null) 'audio': audio!.toMap(),
      if(video!=null) 'video': video!.toMap(),
      if(images!=null) 'images': images!.map((e) =>e!.toMap()).toList(),
      if(file!=null) 'file': file!.toMap()
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      recCryptedText: map['recCryptedText'],
      senderCryptedText: map['senderCryptedText'],
      messageType: ChatMessageType.values[map['messageType']],
      messageStatus: MessageStatus.values[map['messageStatus']],
      sender: map["sender"]!=null ? NSender.fromMap(map["sender"]) : null,
      receiver: map["receiver"]!=null ? NReceiver.fromMap(map["receiver"]) : null,
      messageTime: map["messageTime"],
      isRemoved: map['isRemoved'],
      video: map['video']!=null ? MediaReference.fromMap(map['video']):null,
      audio: map['audio']!=null ? MediaReference.fromMap(map['audio']):null,
      images: map['images'] !=null ? (map['images']as List<dynamic>).map((e) =>MediaReference.fromMap(e)).toList() : null,
      file: map['file']!=null ? MediaReference.fromMap(map['file']):null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMessage(recCryptedText: $recCryptedText, messageType: $messageType, messageStatus: $messageStatus, senderUid: $sender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatMessage &&
      other.recCryptedText == recCryptedText &&
      other.messageType == messageType &&
      other.messageStatus == messageStatus &&
      other.sender == sender;
  }

  @override
  int get hashCode {
    return recCryptedText.hashCode ^
      messageType.hashCode ^
      messageStatus.hashCode ^
      sender.hashCode;
  }
}