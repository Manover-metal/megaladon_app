import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/order_model.dart';

Map<String, dynamic> _card(Map<String, dynamic> extra) => {
      'id': 1,
      'title': 'Заказ',
      'description': 'Описание',
      'count_offers': 0,
      'created_at': '20.09.2026',
      'status': 'Активен',
      'status_code': 2,
      ...extra,
    };

void main() {
  test('fromJson читает content_changed', () {
    final order = OrderModel.fromJsonMini(_card({'content_changed': true}));

    expect(order.contentChanged, isTrue);
  });

  test('без content_changed поле остаётся false', () {
    final order = OrderModel.fromJsonMini(_card({}));

    expect(order.contentChanged, isFalse);
  });

  test('hasUpdates учитывает правку заказа', () {
    final order = OrderModel.fromJsonMini(_card({'content_changed': true}));

    expect(order.hasUpdates, isTrue);
  });
}
