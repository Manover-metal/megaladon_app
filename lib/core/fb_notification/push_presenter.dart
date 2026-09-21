import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef PushTapHandler = void Function(Map<String, dynamic> data);

/// Показ push-уведомлений, пока приложение открыто.
///
/// Когда приложение свёрнуто или убито, уведомление рисует сама система из
/// notification-блока payload-а — код для этого не нужен. А вот в foreground
/// платформы расходятся, поэтому и обработка разная:
///
///  * iOS умеет показать баннер поверх открытого приложения сам, надо лишь
///    попросить. Рисовать там ещё и локальное уведомление — значит получить
///    два одинаковых.
///  * Android в foreground не показывает ничего, поэтому уведомление собираем
///    вручную через flutter_local_notifications.
class PushPresenter {
  /// Канал заводим явно: на Android 8+ без него уведомление не покажется, а
  /// автоматический fallback-канал FCM называется «Разное» и не даёт
  /// пользователю отключить именно уведомления о заказах.
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'manover_orders',
    'Заказы',
    description: 'Статусы заказов, отклики и сообщения',
    importance: Importance.high,
  );

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static PushTapHandler? _onTap;

  static Future<void> initialize({required PushTapHandler onTap}) async {
    _onTap = onTap;

    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      return;
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      ),
      onDidReceiveNotificationResponse: _handleTap,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Нарисовать уведомление о пришедшем в foreground сообщении. На iOS ничего
  /// не делает — там баннер показывает система.
  static Future<void> show(RemoteMessage message) async {
    if (!Platform.isAndroid) return;

    final notification = message.notification;
    if (notification == null) return;

    await _plugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      // data уходит в payload целиком: колбэк тапа по локальному уведомлению
      // получает только строку, самого RemoteMessage там уже нет.
      payload: jsonEncode(message.data),
    );
  }

  static void _handleTap(NotificationResponse response) {
    final payload = response.payload;
    final handler = _onTap;
    if (payload == null || handler == null) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) handler(decoded);
    } catch (_) {
      // Payload пришёл снаружи: битый JSON не должен ронять приложение.
    }
  }
}
