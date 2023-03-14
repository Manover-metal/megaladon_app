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
    return ApiService.I.delete('/auth/logout', data: {
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

  write(AuthModel auth, UserModel user, ExecutorModel? executor, StoreModel? store) async {
    _addInterceptor(auth);
    await IsarService.I.writeTxn(() async {
      await IsarService.I.authModels.put(auth);
      await IsarService.I.userModels.put(user);
      await auth.user.save();

      if(executor != null) {
        await IsarService.I.executorModels.put(executor);
        await auth.executor.save();
      }

      if(store != null) {
        await IsarService.I.storeModels.put(store);
        await auth.store.save();
      }
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