import 'package:dio/dio.dart';

class MessageCreateRequestParams {
  MessageCreateRequestParams({required this.chatId, this.message, this.file});
  final int chatId;
  final String? message;
  final MultipartFile? file;

  FormData toData() {
    final map = <String, dynamic>{'chat_id': chatId};
    if (message != null && message!.isNotEmpty) {
      map['message'] = message;
    }
    final data = FormData.fromMap(map);
    if (file != null) {
      // Имя поля 'file' — как ждёт SendMessageRequest (одиночный файл).
      data.files.add(MapEntry('file', file!));
    }
    return data;
  }
}
