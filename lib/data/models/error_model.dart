import 'package:dio/dio.dart';

class ErrorModel {
  final List<String> messages;

  ErrorModel(this.messages);

  static ErrorModel parseDio(DioError error) {
    dynamic data = error.response?.data;
    if(data?['message'] != null) {
      return ErrorModel([data['message']]);
    } else if(data?['errors'] is List) {
      return ErrorModel(data['errors']);
    } else if(data?['errors'] is Map) {
      return ErrorModel(data['errors'].map((val)=> val));
    }
    return ErrorModel(['Неизвестная ошибка']);
  }
}