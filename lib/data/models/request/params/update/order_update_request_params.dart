import 'package:dio/dio.dart';

class OrderUpdateRequestParams {
  OrderUpdateRequestParams(
      {required this.title,
      required this.description,
      required this.categoryId,
      required this.cityId,
      this.budget,
      this.executionDays,
      this.files = const []});
  final String title;
  final String description;
  final int? budget;
  final int? executionDays;
  final int categoryId;
  final int cityId;
  final List<MultipartFile> files;

  FormData toData() {
    var data = FormData.fromMap({
      'title': title,
      'description': description,
      'budget': budget,
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
