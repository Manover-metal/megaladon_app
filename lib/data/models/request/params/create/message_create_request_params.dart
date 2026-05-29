import 'package:dio/dio.dart';

class MessageCreateRequestParams {
  MessageCreateRequestParams({required this.chatId, required this.message});
  final int chatId;
  final String message;

  FormData toData() {
    var data = FormData.fromMap({'chat_id': chatId, 'message': message});

    return data;
  }
}
