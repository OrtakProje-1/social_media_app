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
  ChatMessage({
    this.text,
    this.messageTime,
    this.messageType,
    this.messageStatus,
    this.senderUid,
    this.isRemoved,
  });


  ChatMessage copyWith({
    String text,
    ChatMessageType messageType,
    MessageStatus messageStatus,
    bool senderUid,
    int messageTime,
    bool isRemoved
  }) {
    return ChatMessage(
      text: text ?? this.text,
      messageType: messageType ?? this.messageType,
      messageStatus: messageStatus ?? this.messageStatus,
      senderUid: senderUid ?? this.senderUid,
      messageTime: messageTime ?? this.messageTime,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'messageType': messageType.index,
      'messageStatus': messageStatus.index,
      'senderUid': senderUid,
      'messageTime': messageTime,
      'isRemoved': isRemoved
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