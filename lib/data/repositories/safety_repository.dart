import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/user_model.dart';

/// Почему жалуются — имена enum и есть значения на проводе.
enum ReportReason { spam, abuse, inappropriate, fake, other }

/// На что жалуются.
enum ReportTarget { user, order, advert, message, store }

/// Жалобы и блокировки: POST /reports, /blocks.
class SafetyRepository {
  Future<List<UserModel>> blocked() =>
      ApiService.I.get<dynamic>('/blocks').then((value) => [
            for (final json in value.data['list'] as List<dynamic>)
              UserModel.fromJson(json as Map<String, dynamic>),
          ]);

  Future<void> block(int userId) =>
      ApiService.I.post<dynamic>('/blocks', data: {'user_id': userId});

  Future<void> unblock(int userId) =>
      ApiService.I.delete<dynamic>('/blocks/$userId');

  /// Возвращает текст ответа сервера («Жалоба отправлена…»), чтобы показать
  /// его как есть — он уже локализован по Accept-Language.
  Future<String?> report({
    required int userId,
    required ReportReason reason,
    ReportTarget target = ReportTarget.user,
    int? targetId,
    String? comment,
  }) =>
      ApiService.I.post<dynamic>('/reports', data: {
        'user_id': userId,
        'reason': reason.name,
        'target_type': target.name,
        if (targetId != null) 'target_id': targetId,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      }).then((value) => value.data?['message'] as String?);
}
