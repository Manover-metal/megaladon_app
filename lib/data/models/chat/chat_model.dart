import 'package:equatable/equatable.dart';
import 'package:megaladon/data/models/chat/message_model.dart';

class ChatModel extends Equatable {
  const ChatModel({
    required this.id,
    this.messages = const [],
    this.lastMessage,
    this.companion,
    this.unreadCount = 0,
  });

  final int id;

  /// Сообщения хранятся отсортированными по возрастанию id (старые сверху,
  /// новые снизу) — так их и рисует экран переписки.
  final List<MessageModel> messages;
  final String? lastMessage;

  /// Второй участник чата (с кем идёт переписка) — для шапки экрана.
  final ChatCompanion? companion;

  /// Сколько сообщений собеседника пользователь ещё не открывал. Считает
  /// бэкенд (`ChatRepo::index`), гасится вызовом `POST /chat/{id}/read`.
  /// В ответе `createChat` поля нет — там непрочитанных быть не может.
  final int unreadCount;

  bool get hasUnread => unreadCount > 0;

  static ChatModel parse(data) => ChatModel(
        id: data['id'] as int,
        messages: const [],
        lastMessage: data['lastMessage'] is List
            ? null
            : data['lastMessage']?['message'] as String?,
        companion: data['companion'] is Map<String, dynamic>
            ? ChatCompanion.fromJson(data['companion'] as Map<String, dynamic>)
            : null,
        unreadCount: data['unread_count'] is num
            ? (data['unread_count'] as num).toInt()
            : 0,
      );

  static List<ChatModel> parseAll(data) => (data as List)
      .map<ChatModel>((item) => ChatModel.parse(item as Map<String, dynamic>))
      .toList();

  ChatModel copyWith({
    List<MessageModel>? messages,
    String? lastMessage,
    ChatCompanion? companion,
    int? unreadCount,
  }) =>
      ChatModel(
        id: id,
        messages: messages ?? this.messages,
        lastMessage: lastMessage ?? this.lastMessage,
        companion: companion ?? this.companion,
        unreadCount: unreadCount ?? this.unreadCount,
      );

  /// Объединяет текущие сообщения с [incoming], убирая дубли по id и заново
  /// сортируя по возрастанию. Используется и для polling (новые сообщения
  /// снизу), и для пагинации вверх (старые сверху).
  ChatModel mergeMessages(List<MessageModel> incoming) {
    final byId = <int, MessageModel>{};
    for (final m in messages) {
      byId[m.id] = m;
    }
    for (final m in incoming) {
      byId[m.id] = m;
    }
    final merged = byId.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return copyWith(messages: merged);
  }

  @override
  List<Object?> get props =>
      [id, messages, lastMessage, companion, unreadCount];
}

/// Краткая инфа о собеседнике из ответа бэкенда (UserPresenter::short()).
class ChatCompanion extends Equatable {
  const ChatCompanion({
    required this.id,
    required this.name,
    this.photoUrl,
    this.isDeleted = false,
  });

  factory ChatCompanion.fromJson(Map<String, dynamic> data) => ChatCompanion(
        id: data['id'] as int,
        name: (data['name'] as String?) ?? '',
        photoUrl: data['photo_url'] as String?,
        isDeleted: data['is_deleted'] == true,
      );

  final int id;
  final String name;
  final String? photoUrl;

  /// Собеседник удалил аккаунт: чат остаётся, имя приходит как «Удалённый
  /// аккаунт», фото не приходит.
  final bool isDeleted;

  @override
  List<Object?> get props => [id, name, photoUrl, isDeleted];
}
