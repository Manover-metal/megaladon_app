import 'dart:async';

import 'package:dio/dio.dart';

/// Единственный держатель access-токена. Ставит его на каждый запрос, а на
/// 401 один раз обновляет пару и повторяет запрос.
///
/// Схема та же, что в attractor (auth_data/auth_interceptor.dart): все запросы,
/// упавшие с 401 одновременно — например, пачка на старте с истёкшим токеном —
/// ждут ОДИН refresh через общий Completer, а не шлют по своему. Иначе первый
/// refresh гасит refresh-токен (он одноразовый), второй получает 401 и
/// выкидывает пользователя из аккаунта.
///
/// Регистрируется в Dio один раз, в [ApiService.initialize].
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;

  static const String _headerName = 'Authorization';

  /// Запрос уже повторён на свежем токене: второй 401 refresh не запускает.
  static const String retriedKey = 'auth.retried';

  /// Сам refresh (и прочие вызовы самой авторизации): без токена в заголовке,
  /// без ожидания идущего refresh и без refresh на свой 401.
  static const String skipKey = 'auth.skip';

  /// 401 на этих ручках означает «неверный код/пароль» или «сессия не
  /// принята», а не «протух access-токен» — свежий токен тут не поможет.
  static const List<String> _authPaths = [
    '/auth/refresh',
    '/auth/login',
    '/auth/confirm-code',
    '/auth/upgrade-token',
  ];

  /// Текущий access-токен; null — гость. Кладёт и снимает AuthRepository.
  String? token;

  /// Обновляет и сохраняет пару, возвращает новый access-токен. null — сервер
  /// отказал (refresh неизвестен/истёк/погашен) и сессии больше нет.
  /// Исключение — сеть или прочий сбой: выходить из-за него нельзя.
  Future<String?> Function()? onRefresh;

  Completer<String?>? _refreshing;

  final StreamController<void> _unauthenticated =
      StreamController<void>.broadcast();

  /// Сессию не вернуть: refresh отклонён. Приходит один раз — вместе с ним
  /// токен сбрасывается, и параллельные 401 второго выхода не вызывают.
  Stream<void> get onUnauthenticated => _unauthenticated.stream;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Бэкенд выдаёт короткий access-токен только клиентам, которые умеют
    // refresh; старым версиям без заголовка — долгий (TokenService::issue).
    options.headers['X-Auth-Refresh'] = '1';

    if (options.extra[skipKey] == true) {
      options.headers.remove(_headerName);
      return handler.next(options);
    }

    // Пока идёт refresh, новые запросы ждут его, а не уходят со старым токеном
    // за заведомым 401.
    final pending = _refreshing;
    if (pending != null) {
      try {
        await pending.future;
      } catch (_) {}
    }

    final current = token;
    if (current != null) {
      options.headers[_headerName] = 'Bearer $current';
    } else {
      // Гостевые запросы уходят без заголовка: битый Bearer заставлял бэкенд
      // отвечать 401 там, где эндпоинт публичный.
      options.headers.remove(_headerName);
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final sent = options.headers[_headerName] as String?;

    // 403 («чужой заказ», «не участник чата») — обычная ошибка доступа.
    if (err.response?.statusCode != 401 ||
        token == null ||
        sent == null ||
        options.extra[skipKey] == true ||
        options.extra[retriedKey] == true ||
        _authPaths.any(options.path.contains)) {
      return handler.next(err);
    }

    // Запрос ушёл со старым токеном, а пару уже обновил кто-то другой —
    // просто повторяем на текущем.
    if (sent != 'Bearer $token') {
      return _retry(options, err, handler);
    }

    final String? fresh;
    try {
      fresh = await (_refreshing?.future ?? _refresh());
    } catch (_) {
      // Сеть пропала посреди refresh — это не повод выходить из аккаунта.
      // Отдаём исходную ошибку, следующий запрос попробует снова.
      return handler.next(err);
    }

    if (fresh == null) {
      _signOut();
      return handler.next(err);
    }
    return _retry(options, err, handler);
  }

  /// Повтор идёт через все интерцепторы, этот тоже — он и ставит свежий токен.
  /// Неудача повтора (500, обрыв) отдаётся как есть: к сессии она отношения
  /// не имеет.
  Future<void> _retry(RequestOptions options, DioException original,
      ErrorInterceptorHandler handler) async {
    try {
      final response = await _dio.fetch<dynamic>(
          options.copyWith(extra: {...options.extra, retriedKey: true}));
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<String?> _refresh() async {
    final refresh = onRefresh;
    if (refresh == null) return null;

    final completer = Completer<String?>();
    // Кто начал refresh, ждёт этот метод, а не completer — на одиночном 401
    // completer никто не слушает, и completeError всплыл бы необработанным.
    completer.future.ignore();
    _refreshing = completer;
    try {
      final result = await refresh();
      completer.complete(result);
      return result;
    } catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      _refreshing = null;
    }
  }

  void _signOut() {
    if (token == null) return;
    token = null;
    _unauthenticated.add(null);
  }
}
