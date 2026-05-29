import 'package:dio/dio.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';

class AdvertCreateRequestParams {
  AdvertCreateRequestParams(
      {required this.title,
      required this.description,
      required this.categoryId,
      required this.cityId,
      required this.additionalPhone,
      required this.media,
      required this.type,
      this.price});
  final String title;
  final String description;
  final int? price;
  final int categoryId;
  final int cityId;
  final String additionalPhone;
  final List<MultipartFile> media;
  final AdvertType type;

  FormData toData() {
    print(type.name);
    var data = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'city_id': cityId,
      'additional_phone': additionalPhone,
      'type': type.name
    });
    for (final element in media) {
      data.files.add(MapEntry('files[]', element));
    }
    return data;
  }
}
