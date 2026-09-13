import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// Статус заказа чипом. До сих пор детальный экран статус вообще не
/// показывал — он влиял только на набор доступных кнопок.
class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({required this.status, super.key});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    // nothing — это «все статусы» в фильтре, а не состояние заказа.
    if (status == OrderStatus.nothing) return const SizedBox.shrink();

    final color = status.color(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.localize(AppLocalizations.of(context)!),
            style: TextStyle(
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
