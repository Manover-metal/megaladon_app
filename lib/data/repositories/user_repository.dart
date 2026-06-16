import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/request/params/update/change_executor_request_params.dart';
import 'package:megaladon/data/models/request/params/update/change_store_request_params.dart';
import 'package:megaladon/data/models/user_model.dart';

class UserRepository {
  Future<UserModel> profile() =>
      ApiService.I.get('/user/profile').then((value) =>
          UserModel.fromJson(value.data['user'] as Map<String, dynamic>));

  Future<UserModel> getUserById(int id) =>
      ApiService.I.get('/user/$id').then((value) =>
          UserModel.fromJson(value.data['user'] as Map<String, dynamic>));

  Future changePhoto(FormData data) => ApiService.I
      .post('/user/update-photo', data: data)
      .then((value) => value.data);

  Future changeExecutor(ChangeExecutorRequestParams params) => ApiService.I
      .put('/user/executor', data: params.toData())
      .then((value) => value.data);

  Future changeStore(ChangeStoreRequestParams params) => ApiService.I
      .put('/store/update', data: params.toData())
      .then((value) => value.data);

  Future changePassword(
          String oldPassword, String password, String passwordConfirmation) =>
      ApiService.I.post('/user/change-password', data: {
        'old_password': oldPassword,
        'password': password,
        'password_confirmation': passwordConfirmation
      }).then((value) => value.data);

  Future changePhoneStepStart({
    required String phone,
    required String password,
  }) =>
      ApiService.I.post('/user/change-phone/start', data: {
        'new_phone': phone,
        'password': password
      }).then((value) => value.data);

  Future changePhoneStepEnd({
    required String phone,
    required String code,
  }) =>
      ApiService.I.post('/user/change-phone/end',
          data: {'phone': phone, 'code': code}).then((value) => value.data);
}
