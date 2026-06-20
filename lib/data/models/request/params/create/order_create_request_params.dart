import 'package:dio/dio.dart';

class OrderCreateRequestParams {
  OrderCreateRequestParams(
      {required this.title,
      required this.description,
      required this.categoryId,
      required this.cityId,
      required this.files,
      this.priceRecommended,
      this.priceMax,
      this.executionDays});
  final String title;
  final String description;
  final int? priceRecommended;
  final int? priceMax;
  final int? executionDays;
  final int categoryId;
  final int cityId;
  final List<MultipartFile> files;

  FormData toData() {
    var data = FormData.fromMap({
      'title': title,
      'description': description,
      'price_recommended': priceRecommended,
      'price_max': priceMax,
      'execution_days': executionDays,
      'category_id': categoryId,
      'city_id': cityId,
    });
    for (final element in files) {
      data.files.add(MapEntry('files[]', element));
    }
    return data;
  }
}
