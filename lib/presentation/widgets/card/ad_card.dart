import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';

/// Позиция в ленте маркетплейса — и товар, и услуга. Фотография занимает
/// квадрат слева: раньше она растягивалась на треть высоты экрана, и в ленту
/// помещалось меньше двух позиций.
class AdCard extends StatelessWidget {
  const AdCard({required this.advert, super.key});
  final AdvertModel advert;

  static const double _thumb = 92;

  Null Function() _onTap(BuildContext context) => () {
        context.router.push(DetailsAdRoute(id: advert.id));
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // У услуги цена — стартовая: работа считается по объёму. Цена
    // необязательна, и без неё строка не рисуется вовсе.
    final amount = advert.priceFormatted;
    final price = amount == null
        ? null
        : advert.type == AdvertType.service
            ? l10n.priceFromAmount(amount)
            : l10n.tenge_price(amount);

    // Услуги почти всегда публикуют без фотографии. Заглушка-квадрат в такой
    // ленте превращается в колонку одинаковых серых плашек, поэтому позиция
    // без фото просто отдаёт текстовому блоку всю ширину.
    final media = advert.media.where((file) => file.active).toList();

    final meta = [
      if (advert.category != null && advert.category!.name.isNotEmpty)
        advert.category!.name,
      if (advert.city != null) advert.city!.name,
      if (advert.createdAt != null) advert.createdAt!,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
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
                if (media.isNotEmpty) ...[
                  _Thumb(url: media.first.url, size: _thumb),
                  const SizedBox(width: 11),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advert.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      if (price != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        ),
                      ],
                      if (meta.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        // Wrap, а не Row: длинное название категории вместе
                        // с городом в 92 px оставшейся ширины не влезает.
                        Wrap(
                          spacing: 9,
                          runSpacing: 2,
                          children: meta
                              .map((item) => Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: scheme.secondary,
                                    ),
                                  ))
                              .toList(),
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

/// Первая фотография позиции.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.size});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        color: scheme.secondaryContainer,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (_, __, ___) =>
              Icon(Icons.image_outlined, color: scheme.secondary),
          errorWidget: (_, __, ___) =>
              Icon(Icons.broken_image_outlined, color: scheme.secondary),
        ),
      ),
    );
  }
}
