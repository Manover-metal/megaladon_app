import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/settings/push_notification_cubit.dart';
import 'package:megaladon/presentation/widgets/notifications/push_disabled_detector.dart';

/// Плашка «уведомления выключены» для профиля: заголовок, пояснение зачем
/// их включать и кнопка действия. Что именно выключено и как это чинить —
/// целиком на [PushDisabledDetector]; когда всё включено, плашки нет вовсе.
///
/// Короткий вариант той же проверки живёт в боковом меню, см.
/// DrawerPushNotice.
class PushDisabledBanner extends StatelessWidget {
  const PushDisabledBanner({super.key, this.probe, this.cubitFactory});

  /// Подменяются в тестах, см. [PushDisabledDetector].
  final PushSystemProbe? probe;
  final PushNotificationCubit Function()? cubitFactory;

  @override
  Widget build(BuildContext context) => PushDisabledDetector(
        probe: probe,
        cubitFactory: cubitFactory,
        builder: (context, info) => _BannerCard(info: info),
      );
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.info});
  final PushDisabledInfo info;

  String _text(AppLocalizations l10n) =>
      info.systemBlocked ? l10n.pushBannerSystemText : l10n.pushBannerText;

  String _action(AppLocalizations l10n) {
    if (!info.systemBlocked) return l10n.pushBannerEnable;

    return info.canAskSystem
        ? l10n.pushBannerAllow
        : l10n.pushBannerOpenSettings;
  }

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
                    _text(l10n),
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: scheme.secondary,
                    ),
                  ),
                  TextButton(
                    onPressed: info.onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: scheme.primary,
                    ),
                    child: Text(
                      _action(l10n),
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
