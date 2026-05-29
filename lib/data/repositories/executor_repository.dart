import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/executor_model.dart';

class ExecutorRepository {
  Future<List<ExecutorModel>> my() =>
      ApiService.I.get('/executor/favorite').then((value) {
        final list = value.data['list'] as List<dynamic>?;
        if (list == null) return [];
        return ExecutorModel.fromJsonList(list
            .map((val) => val['executor'] as Map<String, dynamic>)
            .toList());
      });

  Future addFavorite(int orderId, int executorId) =>
      ApiService.I.post('/executor/favorite',
          data: {'order_id': orderId, 'executor_id': executorId});

  Future<ExecutorModel> getById(int id) =>
      ApiService.I.get('/user/$id').then((value) => ExecutorModel.fromJson(
          value.data['user']['executor'] as Map<String, dynamic>));
}
