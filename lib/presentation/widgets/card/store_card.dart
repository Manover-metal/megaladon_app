import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/icons/icons.dart';
import 'package:megaladon/data/models/store_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';

/// Витрина поставщика в ленте: фотография склада обложкой, под ней название,
/// оценка и город. Раньше карточка была таблицей из двух равных колонок, где
/// адрес переносился в узкой правой половине, а прайс-лист и телефон — то,
/// ради чего в раздел заходят, — не показывались вовсе.
class StoreCard extends StatelessWidget {
  const StoreCard({required this.store, super.key});
  final StoreModel store;

  /// Широкая полоса, а не квадрат: у складов фотографии панорамные, и такая
  /// пропорция масштабируется вместе с шириной экрана — прежние
  /// `size.height / 10` на планшете и телефоне давали разные картинки.
  static const double _coverRatio = 21 / 9;

  Null Function() _onTap(BuildContext context) => () {
        context.router.push(DetailsStoreRoute(storeId: store.id));
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final address = [
      if (store.city != null) store.city!.name,
      if (store.fullAddress.isNotEmpty) store.fullAddress,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _onTap(context),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: scheme.onTertiary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: _coverRatio,
                  child: _Cover(photo: store.photo),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _RatingLine(store: store),
                      if (address.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.5, color: scheme.secondary),
                        ),
                      ],
                      if (store.prices.isNotEmpty || store.hasPhone) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if (store.prices.isNotEmpty)
                              _Chip(text: l10n.chipPrice),
                            if (store.hasPhone) _Chip(text: l10n.chipPhone),
                          ],
                        ),
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

/// Обложка или заглушка с логотипом раздела — фотография есть не у всех.
class _Cover extends StatelessWidget {
  const _Cover({required this.photo});
  final String? photo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: scheme.secondaryContainer,
      alignment: Alignment.center,
      child: Icon(IconPack.market, size: 30, color: scheme.secondary),
    );

    if (photo == null || photo!.isEmpty) return placeholder;

    return CachedNetworkImage(
      imageUrl: photo!,
      fit: BoxFit.cover,
      width: double.infinity,
      progressIndicatorBuilder: (_, __, ___) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );
  }
}

/// Звёзды с оценкой, а рядом — тип магазина. Раньше рейтинг выводился голым
/// числом, и шкалу пользователь додумывал сам.
class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.store});
  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final rating = store.rating;
    final type = store.type?.name;

    final caption = [
      if (rating != null) rating.toStringAsFixed(1) else l10n.noRatings,
      if (type != null && type.isNotEmpty) type,
    ].join(' · ');

    return Row(
      children: [
        if (rating != null) ...[
          RatingStars(rate: rating.toDouble(), size: 13),
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
