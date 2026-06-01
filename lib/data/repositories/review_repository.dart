import 'package:megaladon/core/dio/index.dart';

class ReviewRepository {
  Future<void> review(int id, int rate) =>
      ApiService.I.post('/order/$id/rate', data: {'rate': rate});
}
