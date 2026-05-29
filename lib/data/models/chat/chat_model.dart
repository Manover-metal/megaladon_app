import 'package:megaladon/data/models/chat/message_model.dart';

class ChatModel {
  ChatModel(
      {required this.title,
      required this.id,
      this.messages = const [],
      this.lastMessage});
  final String title;
  final int id;
  final List<MessageModel> messages;
  final String? lastMessage;

  static ChatModel parse(data) {
    print(data['lastMessage'].runtimeType);
    return ChatModel(
        title: data['title'] as String,
        id: data['id'] as int,
        messages: [],
        lastMessage: data['lastMessage'] is List
            ? null
            : data['lastMessage']?['message'] as String?);
  }

  static List<ChatModel> parseAll(data) => (data as List)
      .map<ChatModel>((item) => ChatModel.parse(item as Map<String, dynamic>))
      .toList();

  ChatModel addMessage(List<MessageModel> messages) => ChatModel(
      title: title, id: id, messages: [...messages, ...this.messages]);
}
