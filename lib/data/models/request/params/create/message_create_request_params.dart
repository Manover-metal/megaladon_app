import 'package:dio/dio.dart';

class MessageCreateRequestParams {
  final int chatId;
  final String message;

  MessageCreateRequestParams({
    required this.chatId,
    required this.message
  });

  FormData toData() {
    FormData data = FormData.fromMap({
      'chat_id': chatId,
      'message': message
    });

    return data;
  }
}