import 'package:dio/dio.dart';

class OfferCreateRequestParams {
  final String price;
  final String date;
  final String comment;
  final int cityId;
  final String expiredAt;

  OfferCreateRequestParams({
    required this.price,
    required this.cityId,
    required this.comment,
    required this.date,
    required this.expiredAt
  });

  toData() {
    FormData data = FormData.fromMap({
      'price': int.parse(price),
      'comment': comment,
      'date': date,
      'city_id': cityId,
      'expired_at': expiredAt
    });
    return data;
  }
}