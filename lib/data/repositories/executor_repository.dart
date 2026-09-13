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

  /// Исполнитель по id исполнителя. Раньше здесь был GET /user/{id}: id
  /// исполнителя уходил как id пользователя, находился другой человек без
  /// профиля исполнителя — и разбор падал на `null` («type 'Null' is not a
  /// subtype of type 'Map<String, dynamic>'»).
  Future<ExecutorModel> getById(int id) => ApiService.I
      .get<dynamic>('/executor/$id')
      .then((value) => ExecutorModel.fromJson(
          value.data['executor'] as Map<String, dynamic>));
}
