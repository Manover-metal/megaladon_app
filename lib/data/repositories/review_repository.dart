import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';

class ReviewRepository {
  Future<void> review(int id, FormData data) =>
      ApiService.I.post<dynamic>('/order/$id/rate', data: data);
}
