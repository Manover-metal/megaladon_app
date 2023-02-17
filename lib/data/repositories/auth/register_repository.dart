import 'package:megaladon/core/dio/index.dart';

class RegisterRepository {
  Future registerUser({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required int cityId
  }) {
    return ApiService.I.post('/auth/register', data: {
      "name": name,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "city_id": cityId
    });
  }
}