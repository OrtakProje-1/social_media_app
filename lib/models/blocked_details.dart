import 'dart:convert';

class BlockedDetails {
  final String? blockedUid;
  final DateTime? blockedTime;
  final String? lastMessage;
  BlockedDetails({
    this.blockedUid,
    this.blockedTime,
    this.lastMessage,
  });

  BlockedDetails copyWith({
    String? blockedUid,
    DateTime? blockedTime,
    String? lastMessage,
  }) {
    return BlockedDetails(
      blockedUid: blockedUid ?? this.blockedUid,
      blockedTime: blockedTime ?? this.blockedTime,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blockedUid': blockedUid,
      'blockedTime': blockedTime?.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory BlockedDetails.fromMap(Map<String, dynamic> map) {
    return BlockedDetails(
      blockedUid: map['blockedUid'],
      blockedTime: DateTime.fromMillisecondsSinceEpoch(map['blockedTime']),
      lastMessage: map['lastMessage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockedDetails.fromJson(String source) => BlockedDetails.fromMap(json.decode(source));

  @override
  String toString() => 'BlockedDetails(blockedUid: $blockedUid, blockedTime: $blockedTime, lastMessage: $lastMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BlockedDetails &&
      other.blockedUid == blockedUid &&
      other.blockedTime == blockedTime &&
      other.lastMessage == lastMessage;
  }

  @override
  int get hashCode => blockedUid.hashCode ^ blockedTime.hashCode ^ lastMessage.hashCode;
}
