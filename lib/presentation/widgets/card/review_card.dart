import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:megaladon/data/models/review_model.dart';
import 'package:megaladon/presentation/widgets/avatar/avatar.dart';
import 'package:megaladon/presentation/widgets/image_viewer.dart';
import 'package:megaladon/presentation/widgets/rating/rating_stars.dart';

/// Одна строка отзыва. Раньше это была карточка с янтарной рамкой и янтарным
/// аватаром: в одной строке сходились три источника акцентного цвета —
/// обводка, кружок с буквой и звёзды, — и несколько отзывов подряд
/// превращались в решётку. Рамку и фон теперь даёт список [ReviewsList].
class ReviewRow extends StatelessWidget {
  const ReviewRow({required this.review, super.key});

  final ReviewModel review;

  static const double _avatar = 32;
  static const double _thumb = 64;

  void _openImage(BuildContext context, String url) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => ImageViewerScreen(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = review.authorName ?? '';
    final comment = review.comment;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(name: name, photoUrl: review.authorPhoto, size: _avatar),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 1),
                    RatingStars(rate: review.rate, size: 13),
                  ],
                ),
              ),
              // Дата разбиралась моделью и раньше, но нигде не показывалась:
              // свежий отзыв и трёхлетний выглядели одинаково.
              if (review.createdAt != null)
                Text(
                  DateFormat('dd.MM.yyyy').format(review.createdAt!),
                  style: TextStyle(fontSize: 11, color: scheme.secondary),
                ),
            ],
          ),
          // Отзыв без текста — это просто оценка, а не ошибка загрузки:
          // курсивное «Нет описания» здесь больше не рисуем.
          if (comment != null && comment.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              comment,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: _thumb,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => _openImage(context, review.images[index]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: _thumb,
                      height: _thumb,
                      color: scheme.secondaryContainer,
                      child: CachedNetworkImage(
                        imageUrl: review.images[index],
                        fit: BoxFit.cover,
                        // Заглушка была залита акцентом: при загрузке экран
                        // мигал янтарными плитками.
                        placeholder: (_, __) =>
                            Icon(Icons.image_outlined, color: scheme.secondary),
                        errorWidget: (_, __, ___) => Icon(
                            Icons.broken_image_outlined,
                            color: scheme.secondary),
                      ),
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
