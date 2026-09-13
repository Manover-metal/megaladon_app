import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/order_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/badge/unread_badge.dart';

/// Карточка заказа в ленте. Порядок чтения: статус — заголовок — бюджет —
/// условия. Всё, что карточка показывает, приходит уже в списочном ответе
/// (`OrderPresenter::list`), дополнительных запросов не делает.
class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key});
  final OrderModel order;

  static const double _gap = 9;

  Null Function() _onTap(BuildContext context) => () {
        context.router.push(DetailsOrderRoute(orderId: order.id));
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // onTertiary в обеих темах — цвет обводки полей ввода (#E2E8F0 в светлой,
    // rgb(54,54,54) в тёмной). Он же годится карточке и рамкой, и внутренним
    // разделителем: прежний surface в тёмной теме сливался с фоном карточки.
    final line = scheme.onTertiary;
    final muted = scheme.secondary;
    final ink = theme.textTheme.bodyMedium?.color;

    final hasPrice =
        order.priceRecommendedText != null || order.priceMaxText != null;
    final city = order.city?.name;
    final days = order.executionDays;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: _onTap(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusLine(order: order, muted: muted),
                const SizedBox(height: _gap),
                Text(
                  order.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.28,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
                if (order.description.isNotEmpty) ...[
                  const SizedBox(height: _gap),
                  Text(
                    order.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, height: 1.4, color: muted),
                  ),
                ],
                if (hasPrice) ...[
                  const SizedBox(height: _gap),
                  _PriceLine(order: order, muted: muted),
                ],
                const SizedBox(height: _gap),
                Container(height: 1, color: line),
                const SizedBox(height: _gap),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (city != null)
                            Flexible(
                              child: _Meta(
                                icon: Icons.place_outlined,
                                text: city,
                                color: muted,
                              ),
                            ),
                          if (city != null && days != null)
                            const SizedBox(width: 14),
                          if (days != null)
                            _Meta(
                              icon: Icons.schedule_outlined,
                              text: l10n.cardDays(days.toString()),
                              color: muted,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Meta(
                      icon: Icons.people_outline,
                      text: order.countOffers.toString(),
                      color: muted,
                    ),
                    if (order.newOffersCount > 0) const SizedBox(width: 6),
                    UnreadBadge(count: order.newOffersCount),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Верхняя строка: статус слева, дата справа. Точка перед датой — тот же
/// признак «статус сменился с последнего просмотра», что был раньше у
/// заголовка; число смен никто не считает, поэтому точка, а не счётчик.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.order, required this.muted});
  final OrderModel order;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    // nothing — это «все статусы» в фильтре, а не состояние заказа: если
    // status_code почему-то не пришёл, показываем одну дату.
    final hasStatus = order.status != OrderStatus.nothing;
    final color = order.status.color(context);

    return Row(
      children: [
        if (hasStatus) ...[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              order.status.localize(AppLocalizations.of(context)!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (order.statusChanged) ...[
          const UnreadBadge.dot(visible: true),
          const SizedBox(width: 6),
        ],
        Text(
          order.createdAt,
          style: TextStyle(fontSize: 12, color: muted),
        ),
      ],
    );
  }
}

/// Рекомендованная цена крупно, потолок бюджета — мелкой подписью рядом.
/// Нет рекомендованной (или она нулевая) — крупно идёт потолок, без подписи.
class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.order, required this.muted});
  final OrderModel order;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final recommended = order.priceRecommendedText;
    final max = order.priceMaxText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          l10n.priceAmount((recommended ?? max)!),
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (recommended != null && max != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.cardPriceUpTo(max),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: muted),
            ),
          ),
        ],
      ],
    );
  }
}

/// Иконка + значение одной строкой. Текст сжимается, а не переносится:
/// в мета-строке для второй строки места нет.
class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, color: color),
            ),
          ),
        ],
      );
}
