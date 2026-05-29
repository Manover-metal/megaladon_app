import 'package:dio/dio.dart';

class OfferCreateRequestParams {
  OfferCreateRequestParams({
    required this.price,
    required this.cityId,
    required this.comment,
    required this.date,
  });
  final String price;
  final String date;
  final String comment;
  final int cityId;

  FormData toData() {
    var data = FormData.fromMap({
      'price': int.parse(price),
      'comment': comment,
      'date': date,
      'city_id': cityId,
      'expired_at': '2021-12-12'
    });
    return data;
  }
}
