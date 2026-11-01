enum SupportTicketStatus { open, answered, closed }

/// Обращение в поддержку и ответ на него (GET /support/tickets).
class SupportTicketModel {
  const SupportTicketModel({
    required this.id,
    required this.message,
    required this.attachments,
    required this.status,
    required this.createdAt,
    this.adminReply,
    this.repliedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> data) =>
      SupportTicketModel(
        id: data['id'] as int,
        message: data['message'] as String? ?? '',
        attachments: [
          for (final url in data['attachments'] as List<dynamic>? ?? const [])
            url as String,
        ],
        status: SupportTicketStatus.values.firstWhere(
          (s) => s.name == data['status'],
          orElse: () => SupportTicketStatus.open,
        ),
        createdAt: DateTime.tryParse(data['created_at'] as String? ?? '') ??
            DateTime.now(),
        adminReply: data['admin_reply'] as String?,
        repliedAt: data['replied_at'] != null
            ? DateTime.tryParse(data['replied_at'] as String)
            : null,
      );

  final int id;
  final String message;
  final List<String> attachments;
  final SupportTicketStatus status;
  final DateTime createdAt;
  final String? adminReply;
  final DateTime? repliedAt;
}
