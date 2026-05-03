part of 'chat_cubit.dart';


enum ChatScreenMainStatus {
  loading,
  error,
  success
}

class ChatState extends Equatable {
  final ChatScreenMainStatus status;
  final List<ChatModel> chats;
  final ErrorModel? error;
  final Map<int, List<MessageModel>> loadingMessages;
  final Map<int, List<MessageModel>> errorMessages;
  final int update;
  final Map<int, MessageIndexRequestParams> params;
  final Map<int, bool> isLoadingMessages;

   ChatState({
    this.status = ChatScreenMainStatus.success,
    this.chats = const [],
    this.error,
    Map<int, List<MessageModel>>? loadingMessages,
    Map<int, List<MessageModel>>? errorMessages,
    this.update = 0,
    Map<int, MessageIndexRequestParams>? params,
    Map<int, bool>? isLoadingMessages
  }): this.loadingMessages = loadingMessages ?? {}, this.errorMessages = errorMessages ?? {}, this.params = params ?? {}, this.isLoadingMessages = isLoadingMessages ?? {};

  @override
  List<Object?> get props => [status, chats, error, loadingMessages, errorMessages, update, params, isLoadingMessages];

  ChatState copyWith({
    ChatScreenMainStatus? status,
    List<ChatModel>? chats,
    ErrorModel? error,
    Map<int, List<MessageModel>>? loadingMessages,
    Map<int, List<MessageModel>>? errorMessages,
    int? update,
    Map<int, MessageIndexRequestParams>? params,
    Map<int, bool>? isLoadingMessages
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      error: error,
      loadingMessages: loadingMessages ?? this.loadingMessages,
      errorMessages: errorMessages ?? this.errorMessages,
      update: update ?? this.update,
      params: params ?? this.params,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages
    );
  }

}