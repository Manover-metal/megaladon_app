import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.review, super.key});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    final name = review.authorName ?? '';
    final hasPhoto =
        review.authorPhoto != null && review.authorPhoto!.isNotEmpty;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Автор + звёзды
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: hasPhoto
                    ? CachedNetworkImageProvider(review.authorPhoto!)
                    : null,
                child: hasPhoto
                    ? null
                    : Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              RatingStars(rate: review.rate),
            ],
          ),
          const SizedBox(height: 10),
          // Комментарий или «Нет описания»
          Text(
            review.comment ?? AppLocalizations.of(context)!.no_description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: review.comment == null
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                  fontStyle: review.comment == null
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
          ),
          // Фото (если есть)
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: review.images[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 80,
                      height: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    errorWidget: (_, __, ___) => const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
