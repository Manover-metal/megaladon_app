import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorModel {
  final List<String> messages;

  ErrorModel(this.messages);

  static ErrorModel parseDio(DioError error) {
    dynamic data = error.response?.data;
    print(data);
    try {
      if(data?['message'] != null) {
        return ErrorModel([data['message']]);
      } else if(data?['errors'] is List) {
        return ErrorModel(data['errors']);
      } else if(data?['errors'] is Map) {
        return ErrorModel(data['errors'].map((val)=> val));
      }
    } catch (e) {
      return ErrorModel.nothing;
    }

    return ErrorModel.nothing;
  }

  static ErrorModel get nothing => ErrorModel(['Unknown_error'.tr()]);
}