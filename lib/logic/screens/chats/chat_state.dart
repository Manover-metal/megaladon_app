part of 'chat_cubit.dart';

enum ChatScreenMainStatus { loading, error, success }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatScreenMainStatus.success,
    this.chats = const [],
    this.error,
    this.loadingMessages = const {},
    this.errorMessages = const {},
    this.olderLoading = const {},
    this.hasMoreOlder = const {},
    this.activeChatId,
    this.openRequest,
  });

  /// Последняя просьба открыть чат («Написать», «Чат»). Переход делает
  /// ChatOpenListener — по смене [ChatOpenRequest.id], поэтому поле не
  /// сбрасываем.
  final ChatOpenRequest? openRequest;

  /// Статус загрузки списка чатов.
  final ChatScreenMainStatus status;
  final List<ChatModel> chats;
  final ErrorModel? error;

  /// Оптимистичные отправляемые сообщения (ещё не подтверждённые сервером),
  /// по chatId. У них временный отрицательный id.
  final Map<int, List<MessageModel>> loadingMessages;

  /// Сообщения, которые не удалось отправить, по chatId.
  final Map<int, List<MessageModel>> errorMessages;

  /// Идёт подгрузка более старых сообщений (пагинация вверх), по chatId.
  final Map<int, bool> olderLoading;

  /// Есть ли ещё более старые страницы сообщений, по chatId.
  final Map<int, bool> hasMoreOlder;

  /// Открытый в данный момент чат (его сообщения опрашиваются по таймеру).
  final int? activeChatId;

  /// Сумма непрочитанных по всем чатам — для бейджа в меню.
  int get totalUnread =>
      chats.fold<int>(0, (sum, chat) => sum + chat.unreadCount);

  @override
  List<Object?> get props => [
        status,
        chats,
        error,
        loadingMessages,
        errorMessages,
        olderLoading,
        hasMoreOlder,
        activeChatId,
        openRequest,
      ];

  ChatState copyWith({
    ChatScreenMainStatus? status,
    List<ChatModel>? chats,
    ErrorModel? error,
    Map<int, List<MessageModel>>? loadingMessages,
    Map<int, List<MessageModel>>? errorMessages,
    Map<int, bool>? olderLoading,
    Map<int, bool>? hasMoreOlder,
    int? activeChatId,
    bool clearActiveChatId = false,
    ChatOpenRequest? openRequest,
  }) =>
      ChatState(
        status: status ?? this.status,
        chats: chats ?? this.chats,
        error: error,
        loadingMessages: loadingMessages ?? this.loadingMessages,
        errorMessages: errorMessages ?? this.errorMessages,
        olderLoading: olderLoading ?? this.olderLoading,
        hasMoreOlder: hasMoreOlder ?? this.hasMoreOlder,
        activeChatId:
            clearActiveChatId ? null : (activeChatId ?? this.activeChatId),
        openRequest: openRequest ?? this.openRequest,
      );
}

/// Просьба открыть чат: либо [chat] (с заготовкой [draftMessage]), либо
/// [error], если создать чат не вышло. [id] растёт с каждой просьбой —
/// по нему listener отличает новую просьбу от уже обработанной.
class ChatOpenRequest extends Equatable {
  const ChatOpenRequest({
    required this.id,
    this.chat,
    this.draftMessage,
    this.error,
  });

  final int id;
  final ChatModel? chat;
  final String? draftMessage;
  final ErrorModel? error;

  @override
  List<Object?> get props => [id, chat, draftMessage, error];
}
