import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// Статус подписки исполнителя: активна до даты или не активна.
///
/// Дату окончания отдаёт только `ExecutorPresenter::edited()` в поле
/// `subscription_expired_at`, поэтому баннер показывается лишь на вкладке
/// исполнителя — у магазина такого поля в ответе нет.
class SubscriptionStatusBanner extends StatelessWidget {
  const SubscriptionStatusBanner({required this.expiredAt, super.key});

  /// Окончание оплаченной подписки; null — подписки не было ни разу.
  final DateTime? expiredAt;

  static const _activeColor = Color.fromRGBO(5, 150, 105, 1);

  // Локаль для названий месяцев не инициализируется (initializeDateFormatting
  // нигде не вызывается), поэтому только цифры.
  static final _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isActive = expiredAt?.isAfter(DateTime.now()) ?? false;
    final accent = isActive ? _activeColor : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: accent.withValues(alpha: 0.10),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isActive ? Icons.verified_rounded : Icons.lock_outline_rounded,
            color: accent,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive
                      ? l10n.subscriptionActiveUntil(
                          _dateFormat.format(expiredAt!.toLocal()))
                      : l10n.subscriptionInactive,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isActive
                      ? l10n.subscriptionActiveHint
                      : l10n.subscriptionInactiveHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.35,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
