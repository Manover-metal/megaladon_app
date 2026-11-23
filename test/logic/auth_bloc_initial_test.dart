import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

/// Хранилище, которое умеет падать на чтении, как Keychain на заблокированном
/// iPhone, и считает записи.
class _Storage extends LocaleStorage {
  _Storage({this.readError, String? auth}) {
    if (auth != null) values['auth'] = auth;
  }

  final Exception? readError;
  final Map<String, String> values = {};
  int writes = 0;

  @override
  Future<String?> getString(String key) async {
    if (readError != null) throw readError!;
    return values[key];
  }

  @override
  Future<void> setString(String key, String value) async {
    writes++;
    values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> remove(String key) async => values.remove(key);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  AuthBloc build(_Storage storage) => AuthBloc(
        authRepository: AuthRepository(localeStorage: storage),
        fcmTokenReader: () async => null,
      );

  test('сохранённый токен восстанавливает сессию и перезаписывается', () async {
    final storage =
        _Storage(auth: jsonEncode(AuthModel(token: '7|saved').toJson()));
    final bloc = build(storage)..add(AuthInitialEvent());

    final state = await bloc.stream.first.timeout(const Duration(seconds: 2));
    expect(state, isA<AuthLoginState>());
    expect(ApiService.auth.token, '7|saved');

    // Перезапись переводит старую запись Keychain на first_unlock.
    await pumpEventQueue();
    expect(storage.writes, 1);
    await bloc.close();
  });

  test('ошибка чтения хранилища не роняет блок', () async {
    final errors = <Object>[];
    await runZonedGuarded(() async {
      final bloc = build(_Storage(readError: Exception('keychain locked')))
        ..add(AuthInitialEvent());
      await pumpEventQueue();
      expect(bloc.state, isA<AuthInitial>());
      await bloc.close();
    }, (e, _) => errors.add(e));
    expect(errors, isEmpty);
  });
}
