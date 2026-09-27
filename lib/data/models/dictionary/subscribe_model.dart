import 'package:flutter/foundation.dart';
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

/// Способ оплаты заявки; `name` совпадает со значением `payment_method` в API.
enum PaymentMethod { apple, google, manual }

/// Платформа для API: `ios` или `android`.
String platformName(TargetPlatform platform) =>
    platform == TargetPlatform.iOS ? 'ios' : 'android';

class SubscribeModel {
  SubscribeModel(
      {required this.id,
      required this.type,
      required this.duration,
      required this.price,
      this.appleProductId,
      this.googleProductId});
  final int id;
  final SubscribeType type;

  /// Срок подписки в месяцах: бэкенд хранит его в `subscriptions.validity`
  /// и продлевает инвойс через `addMonths()`.
  final int duration;
  final double price;

  /// product ID в App Store / Google Play; null — через магазин не купить.
  final String? appleProductId;
  final String? googleProductId;

  String? storeProductId(TargetPlatform platform) =>
      platform == TargetPlatform.iOS ? appleProductId : googleProductId;

  // Форма ответа задана SubscriptionPresenter::list(): id, type, duration
  // (это validity, приходит числом), price и product ID магазинов.
  static SubscribeModel fromJson(Map<String, dynamic> data) => SubscribeModel(
      id: Parser.toInt(data['id']),
      type: SubscribeType.parse(data['type']),
      duration: Parser.toInt(data['duration']),
      price: Parser.toDouble(data['price']),
      appleProductId: _productId(data['apple_product_id']),
      googleProductId: _productId(data['google_product_id']));

  // Админка сохраняет очищенное поле пустой строкой.
  static String? _productId(dynamic value) =>
      value is String && value.isNotEmpty ? value : null;

  static List<SubscribeModel> listFromJson(List<dynamic> data) => data
      .map<SubscribeModel>(
          (item) => SubscribeModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
