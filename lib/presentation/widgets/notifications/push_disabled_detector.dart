import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/logic/screens/settings/push_notification_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

/// Системное разрешение на показ пушей.
enum PushSystemStatus {
  /// Ещё не спросили у системы — ничего не показываем.
  unknown,
  granted,

  /// Разрешение ещё не запрашивали: системный диалог покажется.
  notAsked,

  /// Уже запретили: диалога больше не будет, остаются настройки телефона.
  denied,
}

/// Почему пуш не дойдёт и что с этим делать.
class PushDisabledInfo {
  const PushDisabledInfo({
    required this.systemBlocked,
    required this.canAskSystem,
    required this.onAction,
  });

  /// Запрещено в системе. Пока так — серверный флаг ничего не решает.
  final bool systemBlocked;

  /// Системный диалог ещё можно показать (разрешение не запрашивали).
  final bool canAskSystem;

  /// Починить: спросить разрешение, открыть настройки телефона либо
  /// включить серверный флаг.
  final VoidCallback onAction;
}

typedef PushSystemProbe = Future<PushSystemStatus> Function();

typedef PushDisabledBuilder = Widget Function(
  BuildContext context,
  PushDisabledInfo info,
);

/// Общая логика плашек «уведомления выключены». Пуши могут не доходить по
/// двум причинам, и обе проверяем:
///
/// * запрещены в системе — разрешение FirebaseMessaging не выдано или
///   отозвано в настройках телефона;
/// * выключены в приложении — серверный флаг push_notifications (тот же
///   переключатель, что в настройках, см. PushNotificationTile).
///
/// Когда всё включено — или статус ещё не известен — [builder] не зовётся
/// вовсе и в дерево уходит пустой SizedBox. Внешний вид целиком за
/// вызывающим: в профиле это карточка, в меню — строка.
class PushDisabledDetector extends StatelessWidget {
  const PushDisabledDetector({
    required this.builder,
    this.probe,
    this.cubitFactory,
    super.key,
  });

  final PushDisabledBuilder builder;

  /// Подменяются в тестах: настоящие Firebase и сеть там недоступны.
  final PushSystemProbe? probe;
  final PushNotificationCubit Function()? cubitFactory;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) =>
            (cubitFactory?.call() ?? PushNotificationCubit())..init(),
        child: _PushDisabledDetectorView(builder: builder, probe: probe),
      );
}

class _PushDisabledDetectorView extends StatefulWidget {
  const _PushDisabledDetectorView({required this.builder, this.probe});

  final PushDisabledBuilder builder;
  final PushSystemProbe? probe;

  @override
  State<_PushDisabledDetectorView> createState() =>
      _PushDisabledDetectorViewState();
}

class _PushDisabledDetectorViewState extends State<_PushDisabledDetectorView>
    with WidgetsBindingObserver {
  PushSystemStatus _system = PushSystemStatus.unknown;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkSystem();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Вернулись из системных настроек — разрешение могло поменяться.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkSystem();
  }

  Future<void> _checkSystem() async {
    final system = await (widget.probe ?? _firebaseProbe)();
    if (mounted) setState(() => _system = system);
  }

  static Future<PushSystemStatus> _firebaseProbe() async {
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      return _map(settings.authorizationStatus);
    } catch (_) {
      // Узнать не вышло — судим только по серверному флагу.
      return PushSystemStatus.granted;
    }
  }

  static PushSystemStatus _map(AuthorizationStatus status) {
    if (status == AuthorizationStatus.denied) return PushSystemStatus.denied;
    if (status == AuthorizationStatus.notDetermined) {
      return PushSystemStatus.notAsked;
    }

    return PushSystemStatus.granted;
  }

  /// Разрешение ещё не спрашивали — спрашиваем. Уже запретили — системный
  /// диалог больше не появится, остаётся вести в настройки приложения.
  Future<void> _fixSystem() async {
    if (_system == PushSystemStatus.notAsked) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await _checkSystem();
    } else {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PushNotificationCubit, PushNotificationState>(
        builder: (context, state) {
          if (_system == PushSystemStatus.unknown) {
            return const SizedBox.shrink();
          }

          final systemBlocked = _system != PushSystemStatus.granted;
          // Пока флаг грузится или не загрузился — про него молчим.
          final serverOff =
              state.status == PushNotificationStatus.loaded && !state.value;
          if (!systemBlocked && !serverOff) return const SizedBox.shrink();

          return widget.builder(
            context,
            PushDisabledInfo(
              systemBlocked: systemBlocked,
              canAskSystem: _system == PushSystemStatus.notAsked,
              onAction: systemBlocked
                  ? _fixSystem
                  : () => context.read<PushNotificationCubit>().toggle(true),
            ),
          );
        },
      );
}
