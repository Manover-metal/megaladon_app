import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/settings/push_notification_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

/// Плашка «уведомления выключены» для профиля. Пуши могут не доходить по
/// двум причинам, и обе проверяем:
///
/// * запрещены в системе — разрешение FirebaseMessaging не выдано или
///   отозвано в настройках телефона;
/// * выключены в приложении — серверный флаг push_notifications (тот же
///   переключатель, что в настройках, см. PushNotificationTile).
///
/// Когда всё включено — или статус ещё не известен — плашки нет вовсе.
class PushDisabledBanner extends StatelessWidget {
  const PushDisabledBanner({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => PushNotificationCubit()..init(),
        child: const _PushDisabledBannerView(),
      );
}

enum _SystemPermission { unknown, granted, notAsked, denied }

class _PushDisabledBannerView extends StatefulWidget {
  const _PushDisabledBannerView();

  @override
  State<_PushDisabledBannerView> createState() =>
      _PushDisabledBannerViewState();
}

class _PushDisabledBannerViewState extends State<_PushDisabledBannerView>
    with WidgetsBindingObserver {
  _SystemPermission _system = _SystemPermission.unknown;

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
    _SystemPermission system;
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      system = _map(settings.authorizationStatus);
    } catch (_) {
      // Узнать не вышло — судим только по серверному флагу.
      system = _SystemPermission.granted;
    }
    if (mounted) setState(() => _system = system);
  }

  static _SystemPermission _map(AuthorizationStatus status) {
    if (status == AuthorizationStatus.denied) return _SystemPermission.denied;
    if (status == AuthorizationStatus.notDetermined) {
      return _SystemPermission.notAsked;
    }
    return _SystemPermission.granted;
  }

  /// Разрешение ещё не спрашивали — спрашиваем. Уже запретили — системный
  /// диалог больше не появится, остаётся вести в настройки приложения.
  Future<void> _allowInSystem() async {
    if (_system == _SystemPermission.notAsked) {
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
          if (_system == _SystemPermission.unknown) {
            return const SizedBox.shrink();
          }

          final systemOff = _system != _SystemPermission.granted;
          // Пока флаг грузится или не загрузился — про него молчим.
          final serverOff =
              state.status == PushNotificationStatus.loaded && !state.value;
          if (!systemOff && !serverOff) return const SizedBox.shrink();

          final l10n = AppLocalizations.of(context)!;

          // Сначала системный запрет: пока он есть, серверный флаг ничего
          // не решает — пуш всё равно не покажется.
          return _BannerCard(
            text: systemOff ? l10n.pushBannerSystemText : l10n.pushBannerText,
            action: systemOff
                ? (_system == _SystemPermission.notAsked
                    ? l10n.pushBannerAllow
                    : l10n.pushBannerOpenSettings)
                : l10n.pushBannerEnable,
            onAction: systemOff
                ? _allowInSystem
                : () => context.read<PushNotificationCubit>().toggle(true),
          );
        },
      );
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.text,
    required this.action,
    required this.onAction,
  });
  final String text;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(Icons.notifications_off_outlined,
                  size: 20, color: scheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pushBannerTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: scheme.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: scheme.primary,
                    ),
                    child: Text(
                      action,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
