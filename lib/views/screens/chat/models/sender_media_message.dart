

import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/util/enum.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';

class SenderMediaMessage{
  final List<MediaReference?>? refs;
  final String? message;
  final ChatMessageType? type;
  SenderMediaMessage({
    this.refs,
    this.message,
    this.type,
  });
}