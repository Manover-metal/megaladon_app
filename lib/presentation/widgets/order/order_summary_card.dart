import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

/// Сводка заказа: бюджет крупно, остальные условия — парами «ключ →
/// значение». Город и категорию модель парсила и раньше, но экран их не
/// показывал; здесь они наконец видны.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({required this.order, super.key});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    // Бюджет — крупной строкой. Пустой и нулевой не показываем: раньше цены
    // печатались через .toString() и на экране появлялось слово «null».
    final budget = order.budgetText;

    final rows = <_Row>[
      if (order.executionDays != null)
        _Row(l10n.deadlineLabel, l10n.cardDays(order.executionDays.toString())),
      if (order.city != null) _Row(l10n.city, order.city!.name),
      if (order.category != null && order.category!.name.isNotEmpty)
        _Row(l10n.category, order.category!.name),
      _Row(l10n.offersLabel, order.countOffers.toString()),
    ];

    return CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (budget != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  l10n.priceAmount(budget),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.budgetLabel.toLowerCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: scheme.secondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: scheme.onTertiary),
            const SizedBox(height: 12),
          ],
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 9),
            _KeyValue(row: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _Row {
  const _Row(this.key, this.value);
  final String key;
  final String value;
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.row});
  final _Row row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 104,
          child: Text(
            row.key,
            style: TextStyle(fontSize: 13, color: theme.colorScheme.secondary),
          ),
        ),
        Expanded(
          child: Text(
            row.value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}
