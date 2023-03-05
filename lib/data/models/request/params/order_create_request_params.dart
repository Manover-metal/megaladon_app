import 'package:dio/dio.dart';

class OrderCreateRequestParams {
  final String title;
  final String description;
  final int priceRecommended;
  final int priceMax;
  final int categoryId;
  final int cityId;
  final String additionalPhone;

  OrderCreateRequestParams({
    required this.title,
    required this.description,
    required this.priceRecommended,
    required this.priceMax,
    required this.categoryId,
    required this.cityId,
    required this.additionalPhone
  });

  FormData toData() {
    FormData data = FormData.fromMap({
      'title': title,
      'description': description,
      'price_recommended': priceRecommended,
      'price_max': priceMax,
      'category_id': categoryId,
      'city_id': cityId,
      'additional_phone': additionalPhone
    });
    return data;
  }
}