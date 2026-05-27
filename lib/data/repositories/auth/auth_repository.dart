import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/dio/interceptors/auth_interceptors.dart';
import 'package:megaladon/core/isar/index.dart';
import 'package:megaladon/data/models/auth/auth_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class AuthRepository {
  AuthInterceptor? interceptor;

  Future<AuthModel> login({
    required String phone,
    required String password
  }) async {
    return ApiService.I.post('/auth/login', data:{
      "phone": phone,
      "password": password
    }).then((value) {
      return AuthModel.fromJson(value.data);
    });
  }

  Future sendFB({
    required String token,
  }) async {
    return ApiService.I.post('/user/change-token', data: {
      "token": token
    }).then((value) {
      return value;
    }).catchError(( error) {
      if(error is DioError) {
        if(error.response?.statusCode == 403) {
          logout();
        }
      }
      // if(error.statusCode == 403) {
      //
      // }

      // logout();
      // return error;
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
      delete();
    }).catchError((err) {
      delete();
    });
  }

  Future resetPassword({
    required String phone
  }) async {
    return ApiService.I.post('/auth/reset-password', data: {
      'phone': phone
    }).then((value) {
      return value;
    });
  }


  Future<AuthModel?> read() async {
    AuthModel? auth = await IsarService.I.authModels.get(1);
    if(auth != null) {
      _addInterceptor(auth);
    }
    return auth;
  }

  write(AuthModel auth,) async {
    _addInterceptor(auth);
    await IsarService.I.writeTxn(() async {
      await IsarService.I.authModels.put(auth);
      if(auth.user.value != null) {
        await IsarService.I.userModels.put(auth.user.value!);
        await auth.user.save();
      }

      if(auth.executor.value != null) {
        await IsarService.I.executorModels.put(auth.executor.value!);
        await auth.executor.save();
      }
      if(auth.store.value != null) {
        await IsarService.I.storeModels.put(auth.store.value!);
        await auth.store.save();
      }
    });


  }

  addUser(AuthModel auth, UserModel user) async {
    await IsarService.I.writeTxn(() async {
      await IsarService.I.authModels.put(auth);
      await IsarService.I.userModels.put(user);
      await auth.user.save();
    });
  }

  addExecutor(AuthModel auth, ExecutorModel executor) async {
    await IsarService.I.writeTxn(() async {
      await IsarService.I.authModels.put(auth);
      await IsarService.I.executorModels.put(executor);
      await auth.executor.save();
    });
  }

  addStore(AuthModel auth, StoreModel store) async {
    await IsarService.I.writeTxn(() async {
      await IsarService.I.authModels.put(auth);
      await IsarService.I.storeModels.put(store);
      await auth.store.save();
    });
  }

  _addInterceptor(AuthModel auth) {
    interceptor = AuthInterceptor(auth.token!);
    ApiService.addInterceptors(interceptor!);
  }

  delete() async {
    await IsarService.I.writeTxn(() async {
      await IsarService.I.authModels.clear();
    });
  }
}