import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/executor_model.dart';

class ExecutorRepository {
  Future my() => ApiService.I
      .get('/executor/favorite')
      .then((value) => ExecutorModel.fromJsonList(value.data['list']));
}