import 'package:dio/dio.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/data/repositories/auth/log_repository.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    getItApp<TelegramLogerRepository>().sendLog(err.message, err.stackTrace);
    super.onError(err, handler);
  }
}