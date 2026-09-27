import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';
import 'package:megaladon/logic/subscribe/payment_options_cubit.dart';

class _FakeRepository extends SubscribeRepository {
  _FakeRepository({this.manual = true, this.fail = false});
  final bool manual;
  final bool fail;

  @override
  Future<bool> manualAvailable(TargetPlatform platform) async {
    if (fail) throw Exception('network');
    return manual;
  }
}

ProductDetails _product(String id) => ProductDetails(
    id: id,
    title: id,
    description: '',
    price: r'$9.99',
    rawPrice: 9.99,
    currencyCode: 'USD');

SubscribeModel _plan(int id, {String? apple}) => SubscribeModel(
    id: id,
    type: SubscribeType.executor,
    duration: 1,
    price: 5000,
    appleProductId: apple);

void main() {
  test('загружает флаг менеджера и товары магазина для тарифов', () async {
    Set<String>? asked;
    final cubit = PaymentOptionsCubit(
      repository: _FakeRepository(manual: false),
      platform: TargetPlatform.iOS,
      queryProducts: (ids) async {
        asked = ids;
        return {'executor_1m': _product('executor_1m')};
      },
    );

    await cubit.load([_plan(1, apple: 'executor_1m'), _plan(2)]);

    expect(asked, {'executor_1m'});
    expect(cubit.state.manual, isFalse);
    expect(
        cubit.state
            .productFor(_plan(1, apple: 'executor_1m'), TargetPlatform.iOS)
            ?.price,
        r'$9.99');
    expect(cubit.state.productFor(_plan(2), TargetPlatform.iOS), isNull);
  });

  test('без product ID магазин не опрашивается', () async {
    var called = false;
    final cubit = PaymentOptionsCubit(
      repository: _FakeRepository(),
      platform: TargetPlatform.iOS,
      queryProducts: (ids) async {
        called = true;
        return {};
      },
    );

    await cubit.load([_plan(1)]);

    expect(called, isFalse);
    expect(cubit.state.manual, isTrue);
  });

  test('ошибка сети — менеджер скрыт, магазин остаётся', () async {
    final cubit = PaymentOptionsCubit(
      repository: _FakeRepository(fail: true),
      platform: TargetPlatform.iOS,
      queryProducts: (ids) async => {'executor_1m': _product('executor_1m')},
    );

    await cubit.load([_plan(1, apple: 'executor_1m')]);

    expect(cubit.state.manual, isFalse);
    expect(cubit.state.products, hasLength(1));
  });
}
