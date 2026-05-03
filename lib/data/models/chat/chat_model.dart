import 'package:megaladon/data/models/chat/message_model.dart';

class ChatModel {
  final String title;
  final int id;
  final List<MessageModel> messages;
  final String? lastMessage;

  ChatModel({
    required this.title,
    required this.id,
    this.messages = const [],
    this.lastMessage
  });

  static ChatModel parse(data) {
    print(data['lastMessage'].runtimeType);
    return ChatModel(
      title: data['title'],
      id: data['id'],
      messages: [],
      lastMessage: data['lastMessage'] is List ? null : data['lastMessage']?['message']
    );
  }

  static List<ChatModel> parseAll(data) {
    return data.map<ChatModel>((chat) {
      return ChatModel.parse(chat);
    }).toList();
  }


  ChatModel addMessage(List<MessageModel> messages) {
    return ChatModel(
      title: title,
      id: id,
      messages: [ ...messages, ...this.messages]
    );
  }
}