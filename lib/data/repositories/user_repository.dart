import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';

class UserRepository {
  Future profile(int id) => ApiService.I
      .get('/user/$id')
      .then((value) => value.data);

  Future changePhoto(FormData data) => ApiService.I
      .post('/user/update-photo', data: data)
      .then((value) => value.data);
}