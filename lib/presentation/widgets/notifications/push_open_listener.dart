import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/fb_notification/push_presenter.dart';
import 'package:megaladon/core/fb_notification/push_route.dart';

/// Показывает push-уведомления в foreground и открывает по тапу нужный экран.
///
/// Висит в корне приложения (SplashScreen), а не на каждом экране: подписки на
/// FirebaseMessaging глобальные, и listener на каждом смонтированном экране
/// открыл бы заказ столько раз, сколько их в стеке.
///
/// Раньше здесь был метод SplashScreen.listenFB(), который никто не вызывал:
/// у стейта не было initState. Уведомления поэтому работали только в фоне, и
/// тап по ним просто открывал приложение на главной.
class PushOpenListener extends StatefulWidget {
  const PushOpenListener({required this.child, super.key});
  final Widget child;

  @override
  State<PushOpenListener> createState() => _PushOpenListenerState();
}

class _PushOpenListenerState extends State<PushOpenListener> {
  StreamSubscription<RemoteMessage>? _foreground;
  StreamSubscription<RemoteMessage>? _opened;

  @override
  void initState() {
    super.initState();
    unawaited(_wire());
  }

  Future<void> _wire() async {
    await PushPresenter.initialize(onTap: _open);
    if (!mounted) return;

    _foreground = FirebaseMessaging.onMessage.listen(PushPresenter.show);
    _opened = FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _open(message.data));

    // Приложение подняли тапом по уведомлению из убитого состояния.
    // Навигацию откладываем до первого кадра: до него роутера ещё нет.
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial == null || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _open(initial.data));
  }

  void _open(Map<String, dynamic> data) {
    if (!mounted) return;

    final route = routeForPushData(data);
    // Вести некуда — уведомление уже показано, этого достаточно.
    if (route == null) return;

    context.router.navigate(route);
  }

  @override
  void dispose() {
    _foreground?.cancel();
    _opened?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
