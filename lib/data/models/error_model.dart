import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorModel {
  final List<String> messages;

  ErrorModel(this.messages);

  static ErrorModel parseDio(DioError error) {
    dynamic data = error.response?.data;
    try {
      if (data?['errors'] is List) {
        return ErrorModel(List<String>.from(data['errors']));
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

  static ErrorModel get nothing => ErrorModel(['Unknown_error'.tr()]);
}