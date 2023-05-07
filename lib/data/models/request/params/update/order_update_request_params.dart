import 'package:dio/dio.dart';

class OrderUpdateRequestParams {
  final String title;
  final String description;
  final int priceRecommended;
  final int priceMax;
  final int categoryId;
  final int cityId;

  OrderUpdateRequestParams({
    required this.title,
    required this.description,
    required this.priceRecommended,
    required this.priceMax,
    required this.categoryId,
    required this.cityId,
  });

  toData() {
    FormData data = FormData.fromMap({
      'title': title,
      'description': description,
      'price_recommended': priceRecommended,
      'price_max': priceMax,
      'category_id': categoryId,
      'city_id': cityId,
    });
    return data;
  }
}