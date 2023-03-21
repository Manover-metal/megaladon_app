part of 'chat_screen_main_cubit.dart';


enum ChatScreenMainStatus {
  loading,
  error,
  success
}

class ChatScreenMainState extends Equatable {
  final ChatScreenMainStatus status;
  final List<ChatModel> chats;
  final ErrorModel? error;

  const ChatScreenMainState({
    this.status = ChatScreenMainStatus.success,
    this.chats = const [],
    this.error,
  });

  @override
  List<Object?> get props => [status, chats, error];

  ChatScreenMainState copyWith({
    ChatScreenMainStatus? status,
    List<ChatModel>? chats,
    ErrorModel? error,
  }) {
    return ChatScreenMainState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      error: error,
    );
  }

}