import 'package:social_media_app/views/screens/chat/models/chat_message.dart';

class SenderMediaMessage{
  final List<String> urls;
  final String message;
  final ChatMessageType type;
  SenderMediaMessage({
    this.urls,
    this.message,
    this.type,
  });
}