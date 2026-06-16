import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:megaladon/core/dio/interceptors/error_interceptors.dart';
import 'package:megaladon/core/dio/interceptors/language_interceptor.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger_plus/talker_dio_logger_plus.dart';

class ApiService {
  ApiService();

  ApiService.initialize() {
    _dio = Dio();
    _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.headers.addAll({'Accept': 'application/json'});
    _languageInterceptor =
        LanguageInterceptor(WidgetsBinding.instance.platformDispatcher.locale);
    addInterceptors(_languageInterceptor);
    addInterceptors(AdvancedDioLogger(
      talker: Talker(),
      settings: AdvancedDioLoggerSettings(
        printRequestExtra: false,
        printRequestHeaders: false,
        printRequestData: true,
        printResponseData: true,
        printResponseHeaders: false,
        printErrorMessage: true,
      ),
    ));
    addInterceptors(ErrorInterceptor());
  }
  static late Dio _dio;
  static late LanguageInterceptor _languageInterceptor;

  static Dio get I => _dio;

  static void setLocale(Locale locale) =>
      _languageInterceptor.changeLocale(locale);

  static void addInterceptors(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}
