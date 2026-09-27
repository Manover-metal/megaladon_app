import 'package:flutter/foundation.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';

class SubscribeRepository {
  /// Создаёт заявку на тариф; возвращает её uuid — он уходит в покупку
  /// магазина, и по нему вебхук найдёт заявку. Поля ответа лежат в `data`
  /// (форма BaseService::result на бэке).
  Future<String> create(
          SubscribeModel plan, PaymentMethod method, TargetPlatform platform) =>
      ApiService.I.post<dynamic>(
        plan.type == SubscribeType.executor
            ? '/invoice/executor/create'
            : '/invoice/store/create',
        data: {
          'subscription_id': plan.id,
          'payment_method': method.name,
          'platform': platformName(platform),
        },
      ).then((response) => response.data['data']['uuid'] as String);

  /// Показывать ли «Через менеджера» — включается в админке по платформам.
  Future<bool> manualAvailable(TargetPlatform platform) => ApiService.I.get<dynamic>(
        '/payment-methods',
        queryParameters: {'platform': platformName(platform)},
      ).then((response) => response.data['manual'] == true);
}
