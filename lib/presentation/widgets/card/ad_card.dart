import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/themes/dark.dart';
import 'package:megaladon/data/models/advert_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/routing/router.dart';

class AdCard extends StatelessWidget {
  const AdCard({required this.advert, super.key});
  final AdvertModel advert;

  Null Function() _onTap(BuildContext context) => () {
        context.router.push(DetailsAdRoute(id: advert.id));
      };

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: _onTap(context),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiary,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (advert.media.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height / 4,
                          maxHeight: MediaQuery.of(context).size.height / 3),
                      color: Theme.of(context).colorScheme.secondary,
                      child: CachedNetworkImage(
                        imageUrl: advert.media[0].url,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Icon(
                                Icons.image_outlined,
                                size: MediaQuery.of(context).size.width / 10),
                        errorWidget: (context, url, error) => Icon(
                            Icons.error_outline,
                            size: MediaQuery.of(context).size.width / 10),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  advert.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  advert.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (advert.category != null) ...[
                      Icon(Icons.category_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        advert.category!.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (advert.city != null) ...[
                      Icon(Icons.location_on_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        advert.city!.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 13),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppLocalizations.of(context)!
                        .tenge_price(advert.price.toString()),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorSchemeApp.success.color,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      );
}
