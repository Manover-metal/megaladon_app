import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/data/models/request/params/register/register_user_request_params.dart';

class RegisterRepository {
  Future registerUser(RegisterUserRequestParams params) {
    return ApiService.I.post('/auth/register', data: params.toData());
  }

  Future registerExecutor(RegisterExecutorRequestParams params) {
    return ApiService.I.post('/auth/register-executor', data: params.toData());
  }
}