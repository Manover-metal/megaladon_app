
import 'package:megaladon/core/dio/index.dart';

class VerifyRepository {
  Future verifyRegister({
    required String code,
    required String phone,
  }) {
    return ApiService.I.post('/auth/confirm-code', data: {
      "code": code, //101010
      "phone": phone, //+77074054407
    });
  }
}