import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/request/params/register/register_executor_request_params.dart';
import 'package:megaladon/data/models/request/params/register/register_store_request_params.dart';
import 'package:megaladon/data/models/request/params/register/register_user_request_params.dart';
import 'package:megaladon/data/models/store_model.dart';

class RegisterRepository {
  Future registerUser(RegisterUserRequestParams params) =>
      ApiService.I.post('/auth/register', data: params.toData());

  Future<ExecutorModel> registerExecutor(
      RegisterExecutorRequestParams params) async {
    final result = await ApiService.I
        .post('/auth/register-executor', data: params.toData());
    return ExecutorModel.fromJson(result.data['executor']);
  }

  Future<StoreModel> registerStore(RegisterStoreRequestParams params) async {
    final result =
        await ApiService.I.post('/auth/register-store', data: params.toData());
    return StoreModel.fromJsonMini(
        result.data['store'] as Map<String, dynamic>);
  }
}
