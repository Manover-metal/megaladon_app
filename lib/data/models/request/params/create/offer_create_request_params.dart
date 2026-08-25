import 'package:dio/dio.dart';

class OfferCreateRequestParams {
  OfferCreateRequestParams({
    required this.price,
    required this.cityId,
    required this.date,
    this.comment,
  });
  final int price;
  final String date;

  /// Описание отклика необязательно: пустое не отправляем, чтобы бэкенд
  /// сохранил null и карточка отклика показала «нет описания».
  final String? comment;
  final int cityId;

  FormData toData() {
    final map = <String, dynamic>{
      'price': price,
      'date': date,
      'city_id': cityId,
      'expired_at': '2021-12-12'
    };
    if (comment != null && comment!.isNotEmpty) {
      map['comment'] = comment;
    }
    return FormData.fromMap(map);
  }
}
