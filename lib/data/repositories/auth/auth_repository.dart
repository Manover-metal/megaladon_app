import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/dio/interceptors/auth_interceptors.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';

class AuthRepository {
  AuthRepository({required this.localeStorage});

  final LocaleStorage localeStorage;

  static const _authKey = 'auth';

  Future<AuthModel> login(
          {required String phone, required String password}) async =>
      ApiService.I.post('/auth/login', data: {
        'phone': phone,
        'password': password
      }).then(
          (value) => AuthModel.fromJson(value.data as Map<String, dynamic>));

  /// Отправка FCM-токена. Ошибку намеренно глотаем: пуши — не причина рвать
  /// сессию. Раньше на 403 здесь вызывался logout() напрямую, минуя AuthBloc:
  /// сервер стирал токены, хранилище чистилось, а UI оставался «залогиненным»
  /// до следующего запуска. Недействительный токен теперь даёт 401, и выход
  /// делает AuthInterceptor через AuthBloc.
  Future<void> sendFB({
    required String token,
  }) async {
    try {
      await ApiService.I
          .post<dynamic>('/user/change-token', data: {'token': token});
    } catch (error) {
      // ignore: avoid_print
      print('sendFB failed: $error');
    }
  }

  Future confirmRegister({required String phone, required String code}) async =>
      ApiService.I.post('/auth/confirm-code',
          data: {'phone': phone, 'code': code}).then((value) => value);

  /// [notifyServer] = false — выход по 401: токен уже недействителен, и
  /// DELETE /auth/logout с ним вернёт тот же 401, запустив новый цикл выхода.
  Future logout({bool notifyServer = true}) async {
    if (!notifyServer) {
      await delete();
      return;
    }

    await ApiService.I.delete('/auth/logout').then((value) {
      delete();
    }).catchError((Object err) {
      delete();
    });
  }

  /// Ротация пары для [AuthInterceptor.onRefresh]: новый access-токен, или
  /// null, если сервер refresh не принял. Сетевые ошибки пробрасываются —
  /// из-за них из аккаунта не выходим.
  ///
  /// Пара сохраняется до возврата: refresh-токен одноразовый, и потерянный
  /// новый означал бы выход при следующем обновлении.
  Future<String?> refreshSession() async {
    final current = await read();
    final refreshToken = current?.refreshToken;
    if (refreshToken == null) return null;

    try {
      final response = await ApiService.I.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(extra: {AuthInterceptor.skipKey: true}),
      );
      final auth = AuthModel.fromJson(response.data!);
      await write(auth);
      return auth.token;
    } on DioException catch (e) {
      if (_isRejection(e)) return null;
      rethrow;
    }
  }

  /// Обмен вечного токена старой версии приложения на пару. null — токен уже
  /// не принимается. Сетевые ошибки пробрасываются: обменяем в другой раз.
  Future<AuthModel?> upgradeLegacy() async {
    try {
      final response =
          await ApiService.I.post<Map<String, dynamic>>('/auth/upgrade-token');
      final auth = AuthModel.fromJson(response.data!);
      await write(auth);
      return auth;
    } on DioException catch (e) {
      if (_isRejection(e)) return null;
      rethrow;
    }
  }

  static bool _isRejection(DioException e) {
    final code = e.response?.statusCode;
    return code == 401 || code == 403 || code == 422;
  }

  Future forgotPassword({required String phone}) async =>
      ApiService.I.post('/auth/forgot-password',
          data: {'phone': phone}).then((value) => value);

  Future resetPassword({
    required String phone,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async =>
      ApiService.I.post('/auth/reset-password', data: {
        'phone': phone,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }).then((value) => value);

  Future<AuthModel?> read() async {
    final json = await localeStorage.getString(_authKey);
    if (json == null) return null;
    try {
      final auth = AuthModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
      _applyToken(auth);
      // Перезапись переводит запись, сохранённую до смены accessibility
      // (unlocked → first_unlock), на новый уровень доступа.
      unawaited(Future(() => localeStorage.setString(_authKey, json))
          .catchError((Object _) {}));
      return auth;
    } catch (e) {
      return null;
    }
  }

  Future<void> write(AuthModel auth) async {
    _applyToken(auth);
    await localeStorage.setString(_authKey, jsonEncode(auth.toJson()));
  }

  // Интерцептор в Dio один и живёт всё приложение — здесь только обновляем
  // в нём токен. Раньше на каждый read()/write() создавался новый интерцептор
  // с токеном, захваченным в конструкторе, и старые из Dio не удалялись.
  void _applyToken(AuthModel auth) {
    ApiService.auth.token = auth.token;
  }

  Future<void> delete() async {
    ApiService.auth.token = null;
    await localeStorage.remove(_authKey);
  }
}
