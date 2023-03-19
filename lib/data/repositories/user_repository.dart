import 'package:megaladon/core/dio/index.dart';

class UserRepository {
  Future profile(int id) => ApiService.I
      .get('/user/$id')
      .then((value) => value.data);





}