import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// Шторка оплаты тарифа: крупная цена, кнопка магазина своей платформы в одно
/// касание и под разделителем — заявка менеджеру.
class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({
    required this.plan,
    this.storeMethod,
    this.storePrice,
    this.manualPrice,
    super.key,
  });

  final SubscribeModel plan;

  /// apple / google; null — кнопки магазина нет.
  final PaymentMethod? storeMethod;

  /// Цена из магазина, уже в валюте пользователя.
  final String? storePrice;

  /// Цена в тенге; null — «через менеджера» выключен.
  final String? manualPrice;

  static Future<PaymentMethod?> show(
    BuildContext context, {
    required SubscribeModel plan,
    PaymentMethod? storeMethod,
    String? storePrice,
    String? manualPrice,
  }) =>
      showModalBottomSheet<PaymentMethod>(
        context: context,
        // По умолчанию шторка не выше 9/16 экрана — на маленьких телефонах
        // кнопки обрезались бы. Растёт по содержимому, дальше прокрутка.
        isScrollControlled: true,
        builder: (_) => PaymentMethodSheet(
          plan: plan,
          storeMethod: storeMethod,
          storePrice: storePrice,
          manualPrice: manualPrice,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.hintColor;
    final hasStore = storeMethod != null;
    final isApple = storeMethod == PaymentMethod.apple;
    // Магазинная цена главнее: её пользователь и заплатит по кнопке.
    final price = hasStore ? storePrice : manualPrice;
    final perks = plan.type == SubscribeType.executor
        ? [
            l10n.subscriptionExecutorBenefit1Title,
            l10n.subscriptionExecutorBenefit2Title,
            l10n.subscriptionExecutorBenefit3Title,
          ]
        : [
            l10n.subscriptionStoreBenefit1Title,
            l10n.subscriptionStoreBenefit2Title,
          ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.months_count(plan.duration),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontSize: 15, color: muted),
              ),
              const SizedBox(height: 2),
              Text(
                price ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 12),
              for (final perk in perks) _Perk(text: perk),
              const SizedBox(height: 16),
              if (hasStore)
                _StoreButton(
                  icon: isApple
                      ? Icons.shopping_bag_outlined
                      : Icons.play_arrow_rounded,
                  text: l10n.paymentPayIn(isApple
                      ? l10n.paymentMethodAppStore
                      : l10n.paymentMethodGooglePlay),
                  onPressed: () => Navigator.of(context).pop(storeMethod),
                ),
              if (hasStore && manualPrice != null)
                _OrDivider(text: l10n.paymentOr),
              if (manualPrice != null)
                _ManagerButton(
                  text: l10n.paymentManagerRequest(manualPrice!),
                  // Без магазина заявка — единственный путь, выделяем её.
                  primary: !hasStore,
                  onPressed: () =>
                      Navigator.of(context).pop(PaymentMethod.manual),
                ),
              if (hasStore) ...[
                const SizedBox(height: 12),
                Text(
                  isApple
                      ? l10n.paymentCancelHintIos
                      : l10n.paymentCancelHintAndroid,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontSize: 12, height: 1.35, color: muted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_rounded, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 14, color: theme.hintColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// Кнопка магазина контрастная, а не янтарная: цвет текста темы на фоне
/// экрана — тёмная в светлой теме и светлая в тёмной, как кнопки оплаты
/// самих магазинов.
class _StoreButton extends StatelessWidget {
  const _StoreButton(
      {required this.icon, required this.text, required this.onPressed});

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: theme.textTheme.bodyMedium?.color,
        foregroundColor: theme.scaffoldBackgroundColor,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ManagerButton extends StatelessWidget {
  const _ManagerButton(
      {required this.text, required this.primary, required this.onPressed});

  final String text;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    const size = Size.fromHeight(50);
    const textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);

    if (primary) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
            minimumSize: size, shape: shape, textStyle: textStyle),
        child: Text(text),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: size,
        shape: shape,
        textStyle: textStyle,
        foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      child: Text(text),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontSize: 13, color: theme.hintColor),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
