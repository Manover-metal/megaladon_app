import 'package:dio/dio.dart';

class ErrorModel {
  ErrorModel(this.messages);
  final List<String> messages;

  static ErrorModel parseDio(DioException error) {
    dynamic data = error.response?.data;
    try {
      if (data?['errors'] is List) {
        return ErrorModel(List<String>.from(data['errors'] as List<dynamic>));
      } else if (data?['errors'] is Map) {
        final messages = <String>[];
        (data['errors'] as Map).forEach((key, value) {
          if (value is List) {
            messages.addAll(value.cast<String>());
          } else if (value is String) {
            messages.add(value);
          }
        });
        if (messages.isNotEmpty) return ErrorModel(messages);
      }
      if (data?['message'] != null) {
        return ErrorModel([data['message'] as String]);
      }
    } catch (e) {
      return ErrorModel.nothing;
    }
    return ErrorModel.nothing;
  }

  static ErrorModel get nothing => ErrorModel(['Unknown error']);
}
