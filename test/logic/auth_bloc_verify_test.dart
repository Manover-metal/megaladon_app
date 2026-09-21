import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/data/repositories/auth/verify_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';

class _MemoryStorage extends LocaleStorage {
  _MemoryStorage({this.writeError});

  final Exception? writeError;
  final Map<String, String> values = {};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async {
    if (writeError != null) throw writeError!;
    values[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> remove(String key) async => values.remove(key);
}

class _FakeVerifyRepository extends VerifyRepository {
  _FakeVerifyRepository({this.error});

  final Exception? error;

  @override
  Future<AuthModel> verifyRegister({
    required String code,
    required String phone,
  }) async {
    if (error != null) throw error!;
    return AuthModel(token: '23|token');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  AuthBloc buildBloc({
    LocaleStorage? storage,
    Exception? verifyError,
    Future<String?> Function()? fcmTokenReader,
  }) =>
      AuthBloc(
        authRepository:
            AuthRepository(localeStorage: storage ?? _MemoryStorage()),
        verifyRepository: _FakeVerifyRepository(error: verifyError),
        fcmTokenReader: fcmTokenReader ?? () async => 'fcm-token',
      );

  group('AuthBloc verify', () {
    test('уходит из загрузки, даже если FCM-токен не приходит никогда',
        () async {
      final bloc = buildBloc(fcmTokenReader: () => Completer<String?>().future);

      final done = bloc.stream
          .firstWhere((state) => state is! AuthLoadingState)
          .timeout(const Duration(seconds: 2));
      bloc.add(const AuthVerifyEvent('+77074054407', '123456'));

      expect(await done, isA<AuthLoginState>());
      await bloc.close();
    });

    test('сохраняет токен до успеха', () async {
      final storage = _MemoryStorage();
      final bloc = buildBloc(storage: storage);

      final done = bloc.stream
          .firstWhere((state) => state is! AuthLoadingState)
          .timeout(const Duration(seconds: 2));
      bloc.add(const AuthVerifyEvent('+77074054407', '123456'));

      expect(await done, isA<AuthLoginState>());
      expect(storage.values['auth'], isNotNull);
      await bloc.close();
    });

    test('показывает ошибку, если токен не удалось сохранить', () async {
      final bloc = buildBloc(
        storage: _MemoryStorage(writeError: Exception('keychain is locked')),
      );

      final done = bloc.stream
          .firstWhere((state) => state is! AuthLoadingState)
          .timeout(const Duration(seconds: 2));
      bloc.add(const AuthVerifyEvent('+77074054407', '123456'));

      expect(await done, isA<AuthErrorState>());
      await bloc.close();
    });

    test('показывает ошибку сервера', () async {
      final bloc = buildBloc(
        verifyError: DioException(
          requestOptions: RequestOptions(path: '/auth/confirm-code'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/confirm-code'),
            statusCode: 422,
            data: {'message': 'Неверный код'},
          ),
        ),
      );

      final done = bloc.stream
          .firstWhere((state) => state is! AuthLoadingState)
          .timeout(const Duration(seconds: 2));
      bloc.add(const AuthVerifyEvent('+77074054407', '123456'));

      expect(await done, isA<AuthErrorState>());
      await bloc.close();
    });
  });
}
