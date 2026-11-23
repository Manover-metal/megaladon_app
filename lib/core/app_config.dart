import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/core/get.dart';
import 'package:megaladon/core/locale_storage/locale_storage.dart';

/// Настройки интерфейса с бэкенда (GET /app-config), переключаемые в админке
/// без выпуска приложения.
class AppConfig {
  AppConfig._();

  static const _cacheKey = 'app_config.subscriptions_enabled';

  /// Подписки включены. Выключены — экраны и пункты подписок скрыты, а
  /// функции, за которые раньше просили подписку, открыты всем.
  ///
  /// До первого ответа сервера — значение прошлого запуска; при первом
  /// запуске — скрыто: показать подписки на секунду и убрать хуже, чем
  /// показать их на секунду позже.
  static final ValueNotifier<bool> subscriptionsEnabled =
      ValueNotifier<bool>(false);

  /// Значение прошлого запуска сразу, свежее с сервера — в фоне.
  static Future<void> init() async {
    final storage = getItApp<LocaleStorage>();
    subscriptionsEnabled.value = await storage.getBool(_cacheKey) ?? false;
    unawaited(refresh());
  }

  static Future<void> refresh() async {
    try {
      final response =
          await ApiService.I.get<Map<String, dynamic>>('/app-config');
      final enabled = response.data?['subscriptions_enabled'] == true;
      subscriptionsEnabled.value = enabled;
      await getItApp<LocaleStorage>().setBool(_cacheKey, enabled);
    } catch (_) {
      // Нет сети — остаётся значение прошлого запуска.
    }
  }
}

/// Показывает [child], только пока подписки включены.
class SubscriptionsVisible extends StatelessWidget {
  const SubscriptionsVisible({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: AppConfig.subscriptionsEnabled,
        builder: (_, enabled, __) => enabled ? child : const SizedBox.shrink(),
      );
}
