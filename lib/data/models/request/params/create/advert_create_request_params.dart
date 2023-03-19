import 'package:dio/dio.dart';

class AdvertCreateRequestParams {
  final String title;
  final String description;
  final int price;
  final int categoryId;
  final int cityId;
  final String additionalPhone;
  final List<MultipartFile> media;


  AdvertCreateRequestParams({
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.cityId,
    required this.additionalPhone,
    required this.media,
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
    for (var element in media) {
      data.files.add(MapEntry('files[]', element));
    }
    return data;
  }
}