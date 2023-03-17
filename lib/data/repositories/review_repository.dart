import 'package:megaladon/core/dio/index.dart';

class ReviewRepository {
  static Future review(id, rate) => ApiService.I
      .post('/order/$id/rate', data: { 'rate': rate });
}