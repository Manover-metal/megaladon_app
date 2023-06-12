import 'package:megaladon/data/models/chat/message_model.dart';

class ChatModel {
  final String title;
  final int id;
  final List<MessageModel> messages;

  ChatModel({
    required this.title,
    required this.id,
    this.messages = const []
  });

  static ChatModel parse(data) {
    return ChatModel(
      title: data['title'],
      id: data['id'],
      messages: []
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