import 'package:dio/dio.dart';

class AdvertCreateRequestParams {
  final String title;
  final String description;
  final int price;
  final int categoryId;
  final int cityId;
  final String additionalPhone;

  AdvertCreateRequestParams({
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.cityId,
    required this.additionalPhone
  });

  toData() {
    FormData data = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'city_id': cityId,
      'additional_phone': additionalPhone
    });
    return data;
  }
}