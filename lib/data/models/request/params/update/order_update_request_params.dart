import 'package:dio/dio.dart';

class OrderUpdateRequestParams {
  final String title;
  final String description;
  final int? priceRecommended;
  final int? priceMax;
  final int categoryId;
  final int cityId;
  final List<MultipartFile> files;

  OrderUpdateRequestParams({
    required this.title,
    required this.description,
    this.priceRecommended,
    this.priceMax,
    required this.categoryId,
    required this.cityId,
    this.files = const []
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

    for (var element in files) {
      data.files.add(MapEntry('files[]', element));
    }

    return data;
  }
}