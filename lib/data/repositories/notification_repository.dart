import 'package:megaladon/core/dio/index.dart';

/// Тонкая обёртка над API пуш-уведомлений. Как и остальные репозитории в
/// проекте, не ловит исключения сам — отдаёт их наверх в Cubit.
class NotificationRepository {
  /// GET /user/push-status → текущий статус пушей на бэке.
  Future<bool> getPushStatus() => ApiService.I
      .get<Map<String, dynamic>>('/user/push-status')
      .then((value) => _parseStatus(value.data));

  /// POST /user/change-push-status → выставляем флаг пушей.
  /// [pushNotifications] — сам флаг вкл/выкл, не зависит от токена.
  /// [deviceToken] отправляем только если он есть (FCM-токен устройства).
  Future<void> changePushStatus({
    required bool pushNotifications,
    String? deviceToken,
  }) =>
      ApiService.I.post<dynamic>('/user/change-push-status', data: {
        'push_notifications': pushNotifications,
        if (deviceToken != null) 'device_token': deviceToken,
      });

  /// Ответ бэка: `{ "success": true, "push_notifications": bool, ... }`.
  bool _parseStatus(Object? data) {
    if (data is Map && data['push_notifications'] != null) {
      return data['push_notifications'] as bool;
    }

    return false;
  }
}
