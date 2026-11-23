import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

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

  void session(String token, [String? refresh]) => values['auth'] =
      jsonEncode({'token': token, 'refresh_token': refresh});

  Map<String, dynamic>? get saved => values['auth'] == null
      ? null
      : jsonDecode(values['auth']!) as Map<String, dynamic>;
}

/// Сервер в памяти с той же логикой, что у бэкенда: одноразовый refresh,
/// ротация пары, 401 на неизвестный access-токен.
class _Server implements HttpClientAdapter {
  final Set<String> access = {};
  final Set<String> refresh = {};
  final Set<String> legacy = {};
  int refreshCalls = 0;
  int upgradeCalls = 0;
  int _n = 0;

  /// Задержка refresh — окно, в которое прилетают остальные 401.
  Duration refreshDelay = const Duration(milliseconds: 50);
  bool refreshNetworkDown = false;

  /// Отвергать даже свежие токены (проверка, что повтор не зацикливается).
  bool rejectEverything = false;

  final List<String?> protectedAuthHeaders = [];

  Map<String, dynamic> _pair() {
    _n++;
    final pair = {'token': 'a$_n', 'refresh_token': 'r$_n', 'expires_in': 3600};
    access.add('a$_n');
    refresh.add('r$_n');
    return pair;
  }

  ResponseBody _json(int status, Object body) => ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        },
      );

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final bearer = (options.headers['Authorization'] as String?)
        ?.replaceFirst('Bearer ', '');

    switch (options.path) {
      case '/auth/refresh':
        refreshCalls++;
        await Future<void>.delayed(refreshDelay);
        if (refreshNetworkDown) {
          throw DioException.connectionError(
              requestOptions: options, reason: 'offline');
        }
        final token = (options.data as Map)['refresh_token'] as String;
        if (!refresh.remove(token)) {
          return _json(401, {'message': 'Сессия истекла'});
        }
        return _json(200, _pair());
      case '/auth/upgrade-token':
        upgradeCalls++;
        if (bearer == null || !legacy.remove(bearer)) {
          return _json(401, {'message': 'Unauthorized'});
        }
        return _json(200, _pair());
      default:
        protectedAuthHeaders.add(bearer);
        if (rejectEverything || bearer == null || !access.contains(bearer)) {
          return _json(401, {'message': 'Требуется авторизация'});
        }
        return _json(200, {'ok': true});
    }
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Server server;
  late _Storage storage;

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  setUp(() {
    server = _Server();
    storage = _Storage();
    ApiService.I.httpClientAdapter = server;
    ApiService.auth.token = null;
  });

  Future<AuthBloc> coldStart() async {
    final bloc = AuthBloc(
      authRepository: AuthRepository(localeStorage: storage),
      fcmTokenReader: () async => null,
    )..add(AuthInitialEvent());
    await pumpEventQueue();
    return bloc;
  }

  Future<List<Response<dynamic>>> burst(int n) => Future.wait(
      List.generate(n, (i) => ApiService.I.get<dynamic>('/orders/my/$i')));

  test(
      'холодный старт с истёкшим токеном: пачка запросов, ровно один refresh, '
      'все запросы проходят', () async {
    storage.session('expired', 'r0');
    server.refresh.add('r0');

    final bloc = await coldStart();
    expect(bloc.state, isA<AuthLoginState>());

    final responses = await burst(5);

    expect(responses.map((r) => r.statusCode), everyElement(200));
    expect(server.refreshCalls, 1);
    expect(storage.saved, {'token': 'a1', 'refresh_token': 'r1'});
    expect(ApiService.auth.token, 'a1');
    expect(bloc.state, isA<AuthLoginState>());
    await bloc.close();
  });

  test('запрос, начатый во время refresh, ждёт его и идёт с новым токеном',
      () async {
    storage.session('expired', 'r0');
    server.refresh.add('r0');
    final bloc = await coldStart();

    final first = ApiService.I.get<dynamic>('/a');
    // Даём первому запросу получить 401 и запустить refresh.
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final late = ApiService.I.get<dynamic>('/b');

    await Future.wait([first, late]);
    expect(server.refreshCalls, 1);
    // Старый токен ушёл ровно один раз — первым запросом.
    expect(server.protectedAuthHeaders.where((h) => h == 'expired').length, 1);
    await bloc.close();
  });

  test('refresh отклонён — один выход из аккаунта, запросы падают с 401',
      () async {
    storage.session('expired', 'revoked');
    final bloc = await coldStart();
    final states = <AuthState>[];
    final sub = bloc.stream.listen(states.add);

    final results = await Future.wait(List.generate(
        3,
        (i) => ApiService.I
            .get<dynamic>('/x/$i')
            .then<int?>((r) => r.statusCode)
            .catchError((Object e) => (e as DioException).response?.statusCode)));
    await pumpEventQueue();

    expect(results, everyElement(401));
    expect(server.refreshCalls, 1);
    expect(states.whereType<AuthLogoutState>().length, 1);
    expect(storage.saved, isNull);
    await sub.cancel();
    await bloc.close();
  });

  test('сеть пропала во время refresh — из аккаунта не выходим', () async {
    storage.session('expired', 'r0');
    server.refresh.add('r0');
    server.refreshNetworkDown = true;
    final bloc = await coldStart();

    await expectLater(
        ApiService.I.get<dynamic>('/x'), throwsA(isA<DioException>()));
    await pumpEventQueue();
    expect(bloc.state, isA<AuthLoginState>());
    expect(storage.saved?['refresh_token'], 'r0');

    // Сеть вернулась — следующий запрос обновляет пару и проходит.
    server.refreshNetworkDown = false;
    final r = await ApiService.I.get<dynamic>('/x');
    expect(r.statusCode, 200);
    expect(server.refreshCalls, 2);
    await bloc.close();
  });

  test('повтор на свежем токене снова 401 — второго refresh нет', () async {
    storage.session('expired', 'r0');
    server.refresh.add('r0');
    server.rejectEverything = true;
    final bloc = await coldStart();

    await expectLater(
        ApiService.I.get<dynamic>('/x'), throwsA(isA<DioException>()));
    expect(server.refreshCalls, 1);
    await bloc.close();
  });

  test('вечный токен старой версии меняется на пару при запуске', () async {
    storage.session('legacy');
    server.legacy.add('legacy');

    final bloc = await coldStart();

    expect(server.upgradeCalls, 1);
    expect(bloc.state, isA<AuthLoginState>());
    expect(storage.saved, {'token': 'a1', 'refresh_token': 'r1'});
    expect((await ApiService.I.get<dynamic>('/x')).statusCode, 200);
    await bloc.close();
  });

  test('вечный токен уже не принимается — сессия стирается без входа',
      () async {
    storage.session('legacy-dead');

    final bloc = await coldStart();

    expect(bloc.state, isA<AuthInitial>());
    expect(storage.saved, isNull);
    expect(ApiService.auth.token, isNull);
    await bloc.close();
  });
}
