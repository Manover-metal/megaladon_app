import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/data/repositories/subscribe_repository.dart';
import 'package:megaladon/logic/subscribe/subscribe_cubit.dart';

class _FakeRepository extends SubscribeRepository {
  _FakeRepository({this.status});
  final int? status;
  PaymentMethod? method;
  TargetPlatform? platform;

  @override
  Future<String> create(SubscribeModel plan, PaymentMethod method,
      TargetPlatform platform) async {
    this.method = method;
    this.platform = platform;
    if (status != null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/invoice/executor/create'),
        response: Response(
          requestOptions: RequestOptions(path: '/invoice/executor/create'),
          statusCode: status,
          data: {
            'success': false,
            'message': 'Оплата через менеджера сейчас недоступна',
          },
        ),
      );
    }
    return 'uuid-1';
  }
}

final _plan = SubscribeModel(
    id: 1, type: SubscribeType.executor, duration: 1, price: 5000);

void main() {
  test('заявка через менеджера уходит со способом и платформой', () async {
    final repository = _FakeRepository();
    final cubit =
        SubscribeCubit(repository: repository, platform: TargetPlatform.iOS);

    await cubit.requestManager(_plan);

    expect(cubit.state, isA<SubscribeSuccess>());
    expect(repository.method, PaymentMethod.manual);
    expect(repository.platform, TargetPlatform.iOS);
  });

  test('422 от бэка — ошибка с его текстом', () async {
    final cubit = SubscribeCubit(
        repository: _FakeRepository(status: 422),
        platform: TargetPlatform.iOS);

    await cubit.requestManager(_plan);

    final state = cubit.state as SubscribeError;
    expect(state.error.messages.first,
        'Оплата через менеджера сейчас недоступна');
  });
}
