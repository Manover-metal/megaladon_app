import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/dio/interceptors/auth_interceptors.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';

class AuthRepository {
  AuthRepository({required this.localeStorage});

  AuthInterceptor? interceptor;
  final LocaleStorage localeStorage;

  static const _authKey = 'auth';

  Future<AuthModel> login(
          {required String phone, required String password}) async =>
      ApiService.I.post('/auth/login', data: {
        'phone': phone,
        'password': password
      }).then(
          (value) => AuthModel.fromJson(value.data as Map<String, dynamic>));

  Future sendFB({
    required String token,
  }) async =>
      ApiService.I
          .post('/user/change-token', data: {'token': token})
          .then((value) => value)
          .catchError((error) {
            if (error is DioException) {
              if (error.response?.statusCode == 403) {
                logout();
              }
            }
          });

  Future confirmRegister({required String phone, required String code}) async =>
      ApiService.I.post('/auth/confirm-code',
          data: {'phone': phone, 'code': code}).then((value) => value);

  Future logout() async => ApiService.I.delete('/auth/logout').then((value) {
        delete();
      }).catchError((err) {
        delete();
      });

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
      _addInterceptor(auth);
      return auth;
    } catch (e) {
      return null;
    }
  }

  Future<void> write(AuthModel auth) async {
    _addInterceptor(auth);
    await localeStorage.setString(_authKey, jsonEncode(auth.toJson()));
  }

  void _addInterceptor(AuthModel auth) {
    interceptor = AuthInterceptor(auth.token!);
    ApiService.addInterceptors(interceptor!);
  }

  Future<void> delete() async {
    await localeStorage.remove(_authKey);
  }
}
