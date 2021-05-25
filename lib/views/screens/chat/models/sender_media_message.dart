

import 'package:social_media_app/models/media_reference.dart';
import 'package:social_media_app/views/screens/chat/models/chat_message.dart';

class SenderMediaMessage{
  final List<MediaReference?>? urls;
  final String? message;
  final ChatMessageType? type;
  SenderMediaMessage({
    this.urls,
    this.message,
    this.type,
  });
}