import 'dart:async';

import 'package:dio/dio.dart';

/// Единственный держатель access-токена и единственный источник сигнала
/// «токен больше не действителен».
///
/// Регистрируется в Dio один раз, в [ApiService.initialize]. Раньше интерцептор
/// создавался заново на каждый `read()`/`write()` в AuthRepository и захватывал
/// токен в конструкторе: в Dio копились интерцепторы со старыми токенами, а
/// после выхода из аккаунта оставался интерцептор с уже мёртвым токеном.
class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  static const String _headerName = 'Authorization';

  /// Текущий access-токен; null — гость. Кладёт и снимает AuthRepository.
  String? token;

  final StreamController<void> _unauthenticated =
      StreamController<void>.broadcast();

  /// Срабатывает, когда бэкенд ответил 401 на запрос с токеном, т.е. токен
  /// недействителен и нужно выйти из аккаунта. Событие приходит один раз:
  /// вместе с ним токен сбрасывается, поэтому параллельные 401 по другим
  /// запросам второго выхода не вызывают.
  Stream<void> get onUnauthenticated => _unauthenticated.stream;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final current = token;
    if (current != null) {
      options.headers[_headerName] = 'Bearer $current';
    } else {
      // Гостевые запросы уходят без заголовка: битый Bearer заставлял бэкенд
      // отвечать 401 там, где эндпоинт публичный.
      options.headers.remove(_headerName);
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 — единственный повод разлогинить: токена нет или он недействителен.
    // 403 («чужой заказ», «не участник чата», «не исполнитель») — обычная
    // ошибка доступа, её пробрасываем экрану. Раньше на 403 выходили из
    // аккаунта из 17 разных мест, в том числе из фонового опроса чатов.
    if (err.response?.statusCode == 401 &&
        token != null &&
        err.requestOptions.headers.containsKey(_headerName)) {
      token = null;
      _unauthenticated.add(null);
    }
    super.onError(err, handler);
  }
}
