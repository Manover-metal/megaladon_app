import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/core/fb_notification/push_route.dart';
import 'package:megaladon/presentation/routing/router.dart';

/// Куда вести по тапу на пуш. Бэкенд кладёт в data только строки
/// (FcmPushNotification::stringifyData), но данные приходят снаружи, поэтому
/// разбор обязан переживать любой мусор, не роняя приложение.
void main() {
  List<String> chain(PageRouteInfo route) =>
      route.flattened.map((r) => r.routeName).toList();

  test('order_id ведёт на карточку заказа через вкладку заказов', () {
    final route = routeForPushData({'order_id': '42'});

    expect(route, isNotNull);
    expect(
      chain(route!),
      [InitialRouter.name, OrderRouter.name, DetailsOrderRoute.name],
    );
  });

  test('id заказа пробрасывается в аргументы маршрута', () {
    final route = routeForPushData({'order_id': '42'})!;

    final args = route.flattened.last.args! as DetailsOrderRouteArgs;
    expect(args.orderId, 42);
  });

  test('числовой order_id принимается наравне со строковым', () {
    final route = routeForPushData({'order_id': 42})!;

    expect((route.flattened.last.args! as DetailsOrderRouteArgs).orderId, 42);
  });

  test('без order_id маршрута нет', () {
    expect(routeForPushData({'type': 'order_completed'}), isNull);
  });

  test('пустой payload маршрута не даёт', () {
    expect(routeForPushData({}), isNull);
  });

  test('нечисловой order_id игнорируется', () {
    expect(routeForPushData({'order_id': 'abc'}), isNull);
  });

  test('null в order_id игнорируется', () {
    expect(routeForPushData({'order_id': null}), isNull);
  });

  // Идентификаторы в базе начинаются с единицы: 0 приходит там, где
  // исполнитель не выбран, и открывать по нему нечего.
  test('нулевой и отрицательный id игнорируются', () {
    expect(routeForPushData({'order_id': '0'}), isNull);
    expect(routeForPushData({'order_id': '-5'}), isNull);
  });
}
