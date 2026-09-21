import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';

/// Строка исполнителя в списке. Главное здесь — какие работы человек делает:
/// `services` модель разбирала и раньше, но карточка их не показывала, зато
/// половину её высоты занимала кнопка «Подробнее» во всю ширину.
class ExecutorCard extends StatelessWidget {
  const ExecutorCard({required this.executor, super.key});
  final ExecutorModel executor;

  static const double _avatar = 60;

  /// Больше трёх услуг в строку не влезает — остальные сворачиваем в «+N».
  static const int _visibleServices = 3;

  Null Function() _onTap(BuildContext context) => () {
        context.router.navigate(InitialRouter(children: [
          OrderRouter(children: [DetailsExecutorRoute(executorId: executor.id)])
        ]));
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          // Раньше нажималась только кнопка; теперь открывается вся строка.
          onTap: _onTap(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: scheme.onTertiary),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  name: executor.name,
                  photoUrl: executor.photo,
                  size: _avatar,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        executor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              executor.isDeleted ? FontStyle.italic : null,
                          color: executor.isDeleted
                              ? theme.disabledColor
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      if (!executor.isDeleted) ...[
                        const SizedBox(height: 5),
                        _RatingLine(executor: executor),
                        if (executor.services.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _Services(
                            services: executor.services,
                            visible: _visibleServices,
                          ),
                        ],
                      ],
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

/// Звёзды и оценка, рядом — число выполненных заказов. Раньше рейтинг
/// печатался числом «0.0» даже у исполнителя без единого отзыва.
class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.executor});
  final ExecutorModel executor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final rating = executor.rating;
    final orders = executor.countOrders;

    final caption = [
      if (rating != null) rating.toStringAsFixed(1) else l10n.noRatings,
      if (orders != null) '$orders ${l10n.metricOrders}',
    ].join(' · ');

    return Row(
      children: [
        if (rating != null) ...[
          RatingStars(rate: rating, size: 13),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.5, color: scheme.secondary),
          ),
        ),
      ],
    );
  }
}

class _Services extends StatelessWidget {
  const _Services({required this.services, required this.visible});
  final List<ServiceTypeModel> services;
  final int visible;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shown = services.take(visible).toList();
    final rest = services.length - shown.length;

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        for (final service in shown) _Chip(text: service.name),
        if (rest > 0) _Chip(text: l10n.plusCount(rest.toString())),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.onTertiary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, height: 1.3, color: scheme.secondary),
      ),
    );
  }
}
