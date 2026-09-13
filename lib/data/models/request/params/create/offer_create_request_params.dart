import 'package:dio/dio.dart';
import 'package:megaladon/data/models/offer_model.dart';

class OfferCreateRequestParams {
  OfferCreateRequestParams({
    required this.price,
    required this.cityId,
    required this.date,
    this.priceType = OfferPriceType.total,
    this.comment,
  });
  final int price;

  /// За что цена: за всю работу или за штуку.
  final OfferPriceType priceType;
  final String date;

  /// Описание отклика необязательно: пустое не отправляем, чтобы бэкенд
  /// сохранил null и карточка отклика показала «нет описания».
  final String? comment;
  final int cityId;

  FormData toData() {
    // expired_at не шлём: раньше здесь стояла заглушка 2021-12-12, и каждый
    // отклик сразу показывался «Истёк». Срок отклика никто не задаёт.
    final map = <String, dynamic>{
      'price': price,
      'price_type': priceType.apiValue,
      'date': date,
      'city_id': cityId,
    };
    if (comment != null && comment!.isNotEmpty) {
      map['comment'] = comment;
    }
    return FormData.fromMap(map);
  }
}
