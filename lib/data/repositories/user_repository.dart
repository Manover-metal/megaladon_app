import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';

class UserRepository {
  Future profile(int id) => ApiService.I
      .get('/user/$id')
      .then((value) => value.data);

  Future addPrice(FormData data) => ApiService.I
      .post('/store/price', data: data);

  Future deletePrice(int id) => ApiService.I
      .post('/store/price/$id/deactivate');

}