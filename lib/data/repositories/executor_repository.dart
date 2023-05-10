import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class ExecutorRepository {
  Future my() => ApiService.I
      .get('/executor/favorite')
      .then((value) => ExecutorModel.fromJsonList(
        value.data['list'].map((val) => val['executor']).toList()
      ));

  Future addFavorite(int orderId, int executorId) => ApiService.I
      .post('/executor/favorite', data: {
        'order_id': orderId,
        'executor_id': executorId
      });

  Future getById(int id) => ApiService.I
      .get('/user/$id')
      .then((value) => ExecutorModel.fromJson(value.data['user']['executor']));
}