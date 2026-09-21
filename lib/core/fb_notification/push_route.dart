import 'package:auto_route/auto_route.dart';
import 'package:megaladon/presentation/routing/router.dart';

/// Куда вести по тапу на push-уведомление.
///
/// Единая точка для всех трёх входов: холодный старт (getInitialMessage),
/// возврат из фона (onMessageOpenedApp) и тап по локальному уведомлению,
/// нарисованному, пока приложение открыто.
///
/// Возвращает null, если вести некуда — payload разбирается снаружи и обязан
/// переживать любой мусор, не роняя навигацию.
PageRouteInfo? routeForPushData(Map<String, dynamic> data) {
  final orderId = _positiveId(data['order_id']);
  if (orderId == null) return null;

  return InitialRouter(children: [
    OrderRouter(children: [DetailsOrderRoute(orderId: orderId)])
  ]);
}

/// FCM отдаёт data строками, но в тестах и при ручной отправке попадается
/// число — принимаем оба вида. Идентификаторы в базе начинаются с единицы,
/// поэтому 0 (им помечен невыбранный исполнитель) и отрицательные отбрасываем.
int? _positiveId(Object? raw) {
  final value = raw is int ? raw : int.tryParse('${raw ?? ''}');
  return value != null && value > 0 ? value : null;
}
