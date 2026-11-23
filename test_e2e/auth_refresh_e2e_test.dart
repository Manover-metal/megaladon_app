// Сквозной тест обновления токена: настоящий клиентский код приложения
// (ApiService, AuthInterceptor, AuthRepository, AuthBloc) против настоящего
// бэкенда в Docker. Запуск — test_e2e/run.sh, он поднимает стенд с access-
// токеном на 3 секунды.
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

const _base = String.fromEnvironment('E2E_URL',
    defaultValue: 'http://127.0.0.1:18080/api');

class _Storage extends LocaleStorage {
  final Map<String, String> values = {};
  @override
  Future<String?> getString(String key) async => values[key];
  @override
  Future<void> setString(String key, String value) async =>
      values[key] = value;
  @override
  Future<bool?> getBool(String key) async => null;
  @override
  Future<void> setBool(String key, bool value) async {}
  @override
  Future<void> remove(String key) async => values.remove(key);

  Map<String, dynamic>? get saved => values['auth'] == null
      ? null
      : jsonDecode(values['auth']!) as Map<String, dynamic>;
}

/// Считает настоящие запросы к серверу (повторы интерцептора тоже).
class _Counter extends Interceptor {
  int refreshes = 0;
  int unauthorized = 0;
  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    if (o.path == '/auth/refresh') refreshes++;
    h.next(o);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler h) {
    if (e.response?.statusCode == 401) unauthorized++;
    h.next(e);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Биндинг подменяет HttpClient заглушкой; здесь нужна настоящая сеть.
  HttpOverrides.global = null;

  final counter = _Counter();

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': _base});
    ApiService.initialize();
    ApiService.I.interceptors.insert(0, counter);
  });

  setUp(() {
    counter
      ..refreshes = 0
      ..unauthorized = 0;
    ApiService.auth.token = null;
  });

  /// Вход «прошлым запуском»: пара в хранилище, процесса уже нет.
  Future<_Storage> previousRunLogin() async {
    final storage = _Storage();
    final repo = AuthRepository(localeStorage: storage);
    final auth = await repo.login(phone: '+77010000001', password: 'demo12345');
    expect(auth.refreshToken, isNotNull, reason: 'бэкенд выдаёт пару');
    await repo.write(auth);
    ApiService.auth.token = null;
    return storage;
  }

  Future<AuthBloc> coldStart(_Storage storage) async {
    final bloc = AuthBloc(
      authRepository: AuthRepository(localeStorage: storage),
      fcmTokenReader: () async => null,
    )..add(AuthInitialEvent());
    await bloc.stream.firstWhere((s) => s is AuthLoginState);
    return bloc;
  }

  // Экраны, которые приложение дёргает разом при открытии.
  Future<List<int?>> openApp() => Future.wait([
        '/user/profile',
        '/order/my',
        '/adverts/my',
        '/blocks',
        '/support/tickets',
        '/chat',
      ].map((p) => ApiService.I.get<dynamic>(p).then((r) => r.statusCode)));

  test(
      'токен истёк, пока приложение было закрыто: при открытии один refresh, '
      'все экраны загрузились, сессия на месте', () async {
    final storage = await previousRunLogin();
    final before = storage.saved!;

    await Future<void>.delayed(const Duration(seconds: 4)); // TTL = 3 с

    final bloc = await coldStart(storage);
    final codes = await openApp();

    expect(codes, everyElement(200));
    expect(counter.refreshes, 1, reason: 'ровно один refresh на всю пачку');
    expect(counter.unauthorized, greaterThan(0),
        reason: 'токен действительно был просрочен');
    expect(storage.saved!['refresh_token'], isNot(before['refresh_token']));
    expect(bloc.state, isA<AuthLoginState>());

    // Повторное открытие на свежем токене — без refresh.
    counter.refreshes = 0;
    expect(await openApp(), everyElement(200));
    expect(counter.refreshes, 0);
    await bloc.close();
  });

  test('несколько истечений подряд: каждый раз один refresh', () async {
    final storage = await previousRunLogin();
    final bloc = await coldStart(storage);

    for (var round = 0; round < 3; round++) {
      await Future<void>.delayed(const Duration(seconds: 4));
      counter.refreshes = 0;
      expect(await openApp(), everyElement(200), reason: 'раунд $round');
      expect(counter.refreshes, 1, reason: 'раунд $round');
    }
    expect(bloc.state, isA<AuthLoginState>());
    await bloc.close();
  });

  test('выход на сервере: refresh отклонён, приложение выходит один раз',
      () async {
    final storage = await previousRunLogin();
    final bloc = await coldStart(storage);
    final logouts = <AuthState>[];
    final sub = bloc.stream.where((s) => s is AuthLogoutState).listen(logouts.add);

    // Вышли с этого устройства «в другом месте»: пара погашена на сервере.
    await ApiService.I.delete<dynamic>('/auth/logout');
    ApiService.auth.token = storage.saved!['token'] as String;

    final codes = await Future.wait(['/blocks', '/support/tickets', '/order/my']
        .map((p) => ApiService.I
            .get<dynamic>(p)
            .then<int?>((r) => r.statusCode)
            .catchError((Object e) => (e as DioException).response?.statusCode)));
    await pumpEventQueue();

    expect(codes, everyElement(401));
    expect(counter.refreshes, 1);
    expect(logouts.length, 1);
    await sub.cancel();
    await bloc.close();
  });
}
