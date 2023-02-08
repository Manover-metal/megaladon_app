import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/isar/index.dart';
import 'package:megaladon/data/models/auth_model.dart';

class AuthRepository {


  Future login({
    required String phone,
    required String password
  }) async {
    return ApiService.I.post('/auth/login', data:{
      "phone": phone,
      "password": password
    }).then((value) {
      return value;
    });
  }

  Future register({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required int cityId
  }) async {
    return ApiService.I.post('/auth/register', data: {
      "name": name,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "city_id": cityId
    }).then((value) {
      return value;
    });
  }

  Future confirmRegister({
    required String phone,
    required String code
  }) async {
    return ApiService.I.post('/auth/confirm-code', data: {
      "phone": phone,
      "code": code
    }).then((value) {
      return value;
    });
  }

  Future logout() async {
    return ApiService.I.delete('/auth/logout').then((value) {
      return value;
    });
  }

  Future resetPassword({
    required String phone
  }) async {
    return ApiService.I.delete('/auth/logout', data: {
      'phone': phone
    }).then((value) {
      return value;
    });
  }


  Future<AuthModel?> read() async {
    return await IsarService.I.authModels.get(0);
  }

  write() {
    // IsarService.I.
  }

  delete() {

  }
}