import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';

/// Ровно то, что отдаёт бэкенд: SubscriptionPresenter::list() —
/// ключ типа называется `type`, а `duration` приходит числом (validity).
Map<String, dynamic> _json({String type = 'executor'}) => <String, dynamic>{
      'id': 3,
      'type': type,
      'duration': 6,
      'price': '5000.00',
    };

void main() {
  test('fromJson читает тип из ключа type', () {
    expect(SubscribeModel.fromJson(_json()).type, SubscribeType.executor);
    expect(SubscribeModel.fromJson(_json(type: 'store')).type,
        SubscribeType.store);
  });

  test('fromJson читает срок в месяцах числом', () {
    expect(SubscribeModel.fromJson(_json()).duration, 6);
  });

  test('fromJson разбирает строковую цену', () {
    expect(SubscribeModel.fromJson(_json()).price, 5000.0);
  });
}
