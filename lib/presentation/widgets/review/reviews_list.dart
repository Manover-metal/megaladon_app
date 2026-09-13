import 'package:flutter/material.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:megaladon/presentation/widgets/card/review_card.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';
import 'package:megaladon/presentation/widgets/section/content_section.dart';

/// Список отзывов: сводка сверху, дальше строки в одной карточке через
/// волосяные разделители. Раньше каждый отзыв был отдельной карточкой с
/// акцентной обводкой — несколько подряд читались как решётка.
class ReviewsList extends StatelessWidget {
  const ReviewsList({
    required this.reviews,
    this.showSummary = true,
    super.key,
  });

  final List<ReviewModel> reviews;

  /// Средняя оценка и распределение по звёздам. Выключается там, где отзывов
  /// заведомо мало и сводка ничего не добавляет.
  final bool showSummary;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSummary) ...[
          ReviewsSummary(reviews: reviews),
          const SizedBox(height: 8),
        ],
        CardBox(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < reviews.length; i++) ...[
                if (i > 0) Container(height: 1, color: scheme.onTertiary),
                ReviewRow(review: reviews[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Средняя оценка и распределение. Считается из уже загруженного списка —
/// бэкенд ничего дополнительно не отдаёт.
class ReviewsSummary extends StatelessWidget {
  const ReviewsSummary({required this.reviews, super.key});

  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final average =
        reviews.fold<double>(0, (sum, r) => sum + r.rate) / reviews.length;

    // Раскладка по звёздам: оценка может прийти дробной, поэтому округляем и
    // прижимаем к диапазону 1..5.
    final buckets = <int, int>{for (var star = 1; star <= 5; star++) star: 0};
    for (final review in reviews) {
      final star = review.rate.round().clamp(1, 5);
      buckets[star] = buckets[star]! + 1;
    }
    final max = buckets.values.fold<int>(0, (a, b) => a > b ? a : b);

    return CardBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 30,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              RatingStars(rate: average, size: 11),
              const SizedBox(height: 2),
              Text(
                l10n.reviewsCount(reviews.length.toString()),
                style: TextStyle(fontSize: 10, color: scheme.secondary),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--) ...[
                  if (star < 5) const SizedBox(height: 3),
                  _Bar(
                    star: star,
                    count: buckets[star]!,
                    max: max == 0 ? 1 : max,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.star, required this.count, required this.max});
  final int star;
  final int count;
  final int max;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = TextStyle(fontSize: 10, color: scheme.secondary);

    return Row(
      children: [
        SizedBox(width: 8, child: Text('$star', style: label)),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: count / max,
              minHeight: 5,
              backgroundColor: scheme.onTertiary,
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 16,
          child: Text('$count', style: label, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
