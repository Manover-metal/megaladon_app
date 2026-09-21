import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/advert_model.dart';

Map<String, dynamic> _json(Map<String, dynamic> extra) => {
      'id': 1,
      'title': 'Токарные работы',
      'description': 'Описание',
      'type': 'service',
      ...extra,
    };

void main() {
  test('цена с бэкенда форматируется с разделителями разрядов', () {
    final advert = AdvertModel.fromJsonAll(_json({'price': 20000}));

    expect(advert.price, 20000);
    expect(advert.priceFormatted, '20 000');
  });

  test('без цены priceFormatted пустой, а не «0»', () {
    final advert = AdvertModel.fromJsonAll(_json({'price': null}));

    expect(advert.price, isNull);
    expect(advert.priceFormatted, isNull);
  });

  test('цена не пришла вовсе — поле остаётся пустым', () {
    final advert = AdvertModel.fromJsonAll(_json({}));

    expect(advert.price, isNull);
    expect(advert.priceFormatted, isNull);
  });

  test('нулевая цена трактуется как отсутствие цены', () {
    final advert = AdvertModel.fromJsonAll(_json({'price': 0}));

    expect(advert.priceFormatted, isNull);
  });
}
