import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/review_model.dart';

void main() {
  test('fromJson парсит рейтинг, автора и список фото', () {
    final review = ReviewModel.fromJson({
      'id': 7,
      'rate': '4.5',
      'comment': 'Отлично',
      'user': {'name': 'Иван', 'photo_url': 'https://x/a.jpg'},
      'media': [
        {'url': 'https://x/1.jpg'},
        {'url': 'https://x/2.jpg'},
      ],
    });

    expect(review.id, 7);
    expect(review.rate, 4.5);
    expect(review.comment, 'Отлично');
    expect(review.authorName, 'Иван');
    expect(review.authorPhoto, 'https://x/a.jpg');
    expect(review.images, ['https://x/1.jpg', 'https://x/2.jpg']);
  });

  test('fromJson без комментария, автора и фото даёт пустые значения', () {
    final review = ReviewModel.fromJson({'id': 1, 'rate': 3});

    expect(review.comment, isNull);
    expect(review.authorName, isNull);
    expect(review.images, isEmpty);
  });
}
