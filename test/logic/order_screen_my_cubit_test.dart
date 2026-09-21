import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/data/models/request/params/index/order_index_request_params.dart';
import 'package:megaladon/data/repositories/auth/auth_repository.dart';
import 'package:megaladon/data/repositories/order_repository.dart';
import 'package:megaladon/logic/auth/auth_bloc.dart';
import 'package:megaladon/logic/screens/orders/my/order_screen_my_cubit.dart';

class _MemoryStorage extends LocaleStorage {
  @override
  Future<String?> getString(String key) async => null;

  @override
  Future<void> setString(String key, String value) async {}

  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> remove(String key) async {}
}

/// Каждый список отвечает независимо: любой из них можно заставить упасть.
class _FakeOrderRepository extends OrderRepository {
  _FakeOrderRepository({this.myFails = false, this.respondedFails = false});

  final bool myFails;
  final bool respondedFails;

  DioException _error(String path) => DioException(
        requestOptions: RequestOptions(path: path),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 404,
          data: {'message': 'Executor not found', 'success': false},
        ),
        type: DioExceptionType.badResponse,
      );

  @override
  Future<List<OrderModel>> indexMy(OrderIndexRequestParams params) async {
    if (myFails) throw _error('/order/my');
    return [];
  }

  @override
  Future<List<OrderModel>> indexMyResponded(
      OrderIndexRequestParams params) async {
    if (respondedFails) throw _error('/order/my-responded');
    return [];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://example.test/api'});
    ApiService.initialize();
  });

  /// AuthBloc остаётся в AuthInitial, поэтому конструктор cubit-а не запускает
  /// refresh() сам и тест управляет загрузкой явно.
  AuthBloc guestBloc() => AuthBloc(
        authRepository: AuthRepository(localeStorage: _MemoryStorage()),
        fcmTokenReader: () async => null,
      );

  OrderScreenMyCubit buildCubit(_FakeOrderRepository repo) =>
      OrderScreenMyCubit(guestBloc(), repository: repo);

  test('сбой откликов не ломает вкладку заказчика', () async {
    final cubit = buildCubit(_FakeOrderRepository(respondedFails: true));

    await cubit.refresh();

    expect(cubit.state.status, OrderScreenMyStatus.success,
        reason: 'мои заказы загрузились — вкладка должна показывать список');
    expect(cubit.state.error, isNull);
    expect(cubit.state.statusResponded, OrderScreenMyStatus.error);
    expect(cubit.state.errorResponded, isNotNull);
  });

  test('сбой моих заказов не ломает вкладку откликов', () async {
    final cubit = buildCubit(_FakeOrderRepository(myFails: true));

    await cubit.refresh();

    expect(cubit.state.statusResponded, OrderScreenMyStatus.success);
    expect(cubit.state.errorResponded, isNull);
    expect(cubit.state.status, OrderScreenMyStatus.error);
    expect(cubit.state.error, isNotNull);
  });

  test('успешная загрузка обоих списков не оставляет ошибок', () async {
    final cubit = buildCubit(_FakeOrderRepository());

    await cubit.refresh();

    expect(cubit.state.status, OrderScreenMyStatus.success);
    expect(cubit.state.statusResponded, OrderScreenMyStatus.success);
    expect(cubit.state.error, isNull);
    expect(cubit.state.errorResponded, isNull);
  });

  /// Списки грузятся параллельно и пишут в одно состояние: успех одного не
  /// должен затирать ошибку другого, каким бы ни был порядок ответов.
  test('повторная загрузка моих заказов не стирает ошибку откликов', () async {
    final cubit = buildCubit(_FakeOrderRepository(respondedFails: true));

    await cubit.refresh();
    await cubit.fetchMy();

    expect(cubit.state.status, OrderScreenMyStatus.success);
    expect(cubit.state.errorResponded, isNotNull,
        reason: 'ошибка откликов должна пережить загрузку соседнего списка');
  });
}
