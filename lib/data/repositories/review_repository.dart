import 'package:dio/dio.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/review_model.dart';

class ReviewRepository {
  Future<void> review(int id, FormData data) =>
      ApiService.I.post<dynamic>('/order/$id/rate', data: data);

  Future<List<ReviewModel>> myReviews() =>
      ApiService.I.get<dynamic>('/executor/my/ratings').then((value) =>
          ReviewModel.listFromJson(value.data['list'] as List<dynamic>));

  Future<List<ReviewModel>> storeReviews(int storeId) =>
      ApiService.I.get<dynamic>('/store/$storeId/ratings').then((value) =>
          ReviewModel.listFromJson(value.data['list'] as List<dynamic>));
}
