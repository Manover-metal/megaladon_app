
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';

class VerifyRepository {
  Future<AuthModel> verifyRegister({
    required String code,
    required String phone,
  }) async {
    final response = await ApiService.I.post('/auth/confirm-code', data: {
      "code": code,
      "phone": phone,
    });
    return AuthModel.fromJson(response.data);
  }
}

