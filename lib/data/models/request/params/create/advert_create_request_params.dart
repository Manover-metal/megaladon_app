import 'package:dio/dio.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';

class AdvertCreateRequestParams {
  final String title;
  final String description;
  final int? price;
  final int categoryId;
  final int cityId;
  final String additionalPhone;
  final List<MultipartFile> media;
  final AdvertType type;


  AdvertCreateRequestParams({
    required this.title,
    required this.description,
    this.price,
    required this.categoryId,
    required this.cityId,
    required this.additionalPhone,
    required this.media,
    required this.type
  });

  toData() {
    print(type.name);
    FormData data = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'city_id': cityId,
      'additional_phone': additionalPhone,
      'type': type.name
    });
    for (var element in media) {
      data.files.add(MapEntry('files[]', element));
    }
    return data;
  }
}