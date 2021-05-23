import 'dart:convert';

enum ChatMessageType { text, audio, image, video,file }
enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final String senderUid;
  final int messageTime;
  final bool isRemoved;
  final List<String> images;
  final String audio;
  final String video;
  final String file;

  ChatMessage({
    this.text,
    this.messageTime,
    this.messageType,
    this.messageStatus,
    this.senderUid,
    this.isRemoved,
    this.audio,
    this.images,
    this.video,
    this.file
  });


  ChatMessage copyWith({
    String text,
    ChatMessageType messageType,
    MessageStatus messageStatus,
    bool senderUid,
    int messageTime,
    bool isRemoved,
    List<String> images,
    String video,
    String audio,
    String file,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      messageType: messageType ?? this.messageType,
      messageStatus: messageStatus ?? this.messageStatus,
      senderUid: senderUid ?? this.senderUid,
      messageTime: messageTime ?? this.messageTime,
      isRemoved: isRemoved ?? this.isRemoved,
      audio: audio ?? this.audio,
      images: images ?? this.images,
      video: video ?? this.video,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'messageType': messageType.index,
      'messageStatus': messageStatus.index,
      'senderUid': senderUid,
      'messageTime': messageTime,
      'isRemoved': isRemoved,
      'audio': audio,
      'video': video,
      'images': images,
      'file': file
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      messageType: ChatMessageType.values[map['messageType']],
      messageStatus: MessageStatus.values[map['messageStatus']],
      senderUid: map['senderUid'],
      messageTime: map["messageTime"],
      isRemoved: map['isRemoved'],
      video: map['video']??null,
      audio: map['audio']??null,
      images: map['images'] !=null ? (map['images']as List<dynamic>).map((e) =>e.toString()).toList() : null,
      file: map['file']??null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMessage(text: $text, messageType: $messageType, messageStatus: $messageStatus, senderUid: $senderUid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatMessage &&
      other.text == text &&
      other.messageType == messageType &&
      other.messageStatus == messageStatus &&
      other.senderUid == senderUid;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      messageType.hashCode ^
      messageStatus.hashCode ^
      senderUid.hashCode;
  }
}