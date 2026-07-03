import 'package:megaladon/core/utils/parser.dart';

class ReviewModel {
  ReviewModel({
    required this.id,
    required this.rate,
    this.comment,
    this.authorName,
    this.authorPhoto,
    this.images = const [],
    this.createdAt,
  });

  final int id;
  final double rate;
  final String? comment;
  final String? authorName;
  final String? authorPhoto;
  final List<String> images;
  final DateTime? createdAt;

  static ReviewModel fromJson(Map<String, dynamic> data) {
    final user = data['user'] as Map<String, dynamic>?;
    final media = data['media'] as List<dynamic>?;
    final createdAt = data['created_at'];

    return ReviewModel(
      id: Parser.toInt(data['id']),
      rate: Parser.toDouble(data['rate']),
      comment: (data['comment'] as String?)?.trim().isNotEmpty == true
          ? data['comment'] as String
          : null,
      authorName: user?['name'] as String?,
      authorPhoto: user?['photo_url'] as String?,
      images: media == null
          ? const []
          : media
              .map((e) => (e as Map<String, dynamic>)['url'] as String?)
              .whereType<String>()
              .toList(),
      createdAt: createdAt is int
          ? DateTime.fromMillisecondsSinceEpoch(createdAt * 1000)
          : null,
    );
  }

  static List<ReviewModel> listFromJson(List<dynamic> data) => data
      .map<ReviewModel>((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
