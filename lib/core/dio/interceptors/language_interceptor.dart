import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class LanguageInterceptor extends Interceptor {
  LanguageInterceptor(Locale locale) : _locale = locale;

  Locale _locale;

  void changeLocale(Locale locale) => _locale = locale;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = _locale.languageCode;
    handler.next(options);
  }
}
