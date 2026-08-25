import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/logic/subscribe/subscribe_cubit.dart';
import 'package:megaladon/presentation/widgets/buttons/elevated_button.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';

/// Карточка тарифа: срок, цена, цена за месяц и кнопка покупки.
///
/// Снекбар об успехе/ошибке слушает сам экран подписок — держать
/// `BlocListener` внутри карточки нельзя, иначе на каждый тариф прилетит
/// по своему снекбару.
class SubscribeCard extends StatelessWidget {
  const SubscribeCard({
    required this.subscribe,
    this.isBest = false,
    this.discountPercent,
    this.isBusy = false,
    super.key,
  });

  final SubscribeModel subscribe;

  /// Лучшая цена за месяц среди тарифов — карточка подсвечивается.
  final bool isBest;

  /// Насколько тариф выгоднее самого дорогого в пересчёте на месяц.
  /// null — бейдж выгоды не показываем.
  final int? discountPercent;

  /// Покупка уже отправлена: кнопки заблокированы, чтобы не купить дважды.
  final bool isBusy;

  bool get _isFree => subscribe.price == 0.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final onPressed =
        isBusy ? null : () => context.read<SubscribeCubit>().buy(subscribe);
    final buttonText = _isFree ? l10n.activate_for_free : l10n.buy;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isBest
            ? Color.alphaBlend(
                primary.withValues(alpha: 0.08), theme.colorScheme.tertiary)
            : theme.colorScheme.tertiary,
        border: Border.all(
          color: isBest ? primary : primary.withValues(alpha: 0.15),
          width: isBest ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.months_count(subscribe.duration),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isFree)
                _Badge(text: l10n.subscriptionBadgeFree, color: primary)
              else if (discountPercent != null)
                _Badge(
                  text: l10n.subscriptionBadgeBest(discountPercent.toString()),
                  color: primary,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _isFree
                ? l10n.subscriptionBadgeFree
                : l10n.tenge_price(_formatAmount(subscribe.price)),
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 28),
          ),
          if (!_isFree && subscribe.duration > 1) ...[
            const SizedBox(height: 4),
            Text(
              l10n.subscriptionPerMonth(
                  _formatAmount(subscribe.price / subscribe.duration)),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: theme.hintColor,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (isBest)
            ElevatedButtonApp(text: buttonText, onPressed: onPressed)
          else
            OutlinedButtonApp(text: buttonText, onPressed: onPressed),
        ],
      ),
    );
  }

  /// Цены приходят числом с плавающей точкой, но в тенге копеек нет:
  /// округляем и разбиваем на разряды неразрывным пробелом.
  static String _formatAmount(double value) {
    final digits = value.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      );
}
