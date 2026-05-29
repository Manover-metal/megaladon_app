import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // getItApp.getAsync<TelegramLogerRepository>().then((value) {
    //   value.sendLog(err.message, err.stackTrace);
    //
    // });
    super.onError(err, handler);
  }
}
