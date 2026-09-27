import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/subscribe_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// Выбор способа оплаты тарифа. На телефоне доступен только магазин своей
/// платформы, поэтому магазинная строка максимум одна.
class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({
    this.storeMethod,
    this.storePrice,
    this.manualPrice,
    super.key,
  });

  /// apple / google; null — магазинной строки нет.
  final PaymentMethod? storeMethod;

  /// Цена из магазина, уже в валюте пользователя.
  final String? storePrice;

  /// Цена в тенге; null — «через менеджера» выключен.
  final String? manualPrice;

  static Future<PaymentMethod?> show(
    BuildContext context, {
    PaymentMethod? storeMethod,
    String? storePrice,
    String? manualPrice,
  }) =>
      showModalBottomSheet<PaymentMethod>(
        context: context,
        builder: (_) => PaymentMethodSheet(
          storeMethod: storeMethod,
          storePrice: storePrice,
          manualPrice: manualPrice,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.paymentMethodTitle,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            if (storeMethod != null)
              ListTile(
                title: Text(storeMethod == PaymentMethod.apple
                    ? l10n.paymentMethodAppStore
                    : l10n.paymentMethodGooglePlay),
                trailing: Text(storePrice ?? ''),
                onTap: () => Navigator.of(context).pop(storeMethod),
              ),
            if (manualPrice != null)
              ListTile(
                title: Text(l10n.paymentMethodManager),
                subtitle: Text(l10n.paymentMethodManagerHint),
                trailing: Text(manualPrice!),
                onTap: () => Navigator.of(context).pop(PaymentMethod.manual),
              ),
          ],
        ),
      ),
    );
  }
}
