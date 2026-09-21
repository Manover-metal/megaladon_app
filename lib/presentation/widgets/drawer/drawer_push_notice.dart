import 'package:flutter/material.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/screens/settings/push_notification_cubit.dart';
import 'package:megaladon/presentation/widgets/notifications/push_disabled_detector.dart';

/// Короткая плашка «уведомления выключены» для бокового меню. В отличие от
/// карточки в профиле — без пояснения: в меню важен ритм списка, поэтому
/// строка занимает две строки текста и тапается целиком.
///
/// Когда с пушами всё в порядке, в дереве остаётся пустой SizedBox.
class DrawerPushNotice extends StatelessWidget {
  const DrawerPushNotice({super.key, this.probe, this.cubitFactory});

  /// Подменяются в тестах, см. [PushDisabledDetector].
  final PushSystemProbe? probe;
  final PushNotificationCubit Function()? cubitFactory;

  @override
  Widget build(BuildContext context) => PushDisabledDetector(
        probe: probe,
        cubitFactory: cubitFactory,
        builder: (context, info) => _NoticeRow(info: info),
      );
}

class _NoticeRow extends StatelessWidget {
  const _NoticeRow({required this.info});
  final PushDisabledInfo info;

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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Material(
        color: scheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: info.onAction,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.notifications_off_outlined,
                    size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pushBannerTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      Text(
                        _action(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
