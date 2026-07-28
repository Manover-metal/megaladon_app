import 'package:megaladon/core/utils/parser.dart';

enum SubscribeType {
  executor,
  store;

  static SubscribeType parse(data) {
    if (data == 'executor') {
      return executor;
    } else {
      return store;
    }
  }
}

class SubscribeModel {
  SubscribeModel(
      {required this.id,
      required this.type,
      required this.duration,
      required this.price});
  final int id;
  final SubscribeType type;

  /// Срок подписки в месяцах: бэкенд хранит его в `subscriptions.validity`
  /// и продлевает инвойс через `addMonths()`.
  final int duration;
  final double price;

  // Форма ответа задана SubscriptionPresenter::list(): id, type, duration
  // (это validity, приходит числом) и price.
  static SubscribeModel fromJson(Map<String, dynamic> data) => SubscribeModel(
      id: Parser.toInt(data['id']),
      type: SubscribeType.parse(data['type']),
      duration: Parser.toInt(data['duration']),
      price: Parser.toDouble(data['price']));

  static List<SubscribeModel> listFromJson(List<dynamic> data) => data
      .map<SubscribeModel>(
          (item) => SubscribeModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
