import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/data/models/request/params/create/message_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/message_index_request_params.dart';

class ChatRepository {
  Future<List<ChatModel>> index() => ApiService.I
      .get('/chat')
      .then((value) => ChatModel.parseAll(value.data['list']));

  // Создаёт (или переиспользует существующий) личный чат с пользователем
  // [userId]. Возвращает чат, чтобы экран мог сразу открыть переписку.
  Future<ChatModel?> create(int userId) => ApiService.I
          .post<dynamic>('/chat/create', data: {'user_id': userId})
          .then((value) {
        final data = value.data;
        final chat = data is Map ? data['chat'] : null;
        return chat is Map<String, dynamic> ? ChatModel.parse(chat) : null;
      });

  Future<MessageModel?> sendMessage(MessageCreateRequestParams params) =>
      ApiService.I
          .post<dynamic>('/chat/send-message', data: params.toData())
          .then((value) {
        final data = value.data;
        final message = data is Map ? data['chat_message'] : null;
        return message is Map<String, dynamic>
            ? MessageModel.fromJson(message)
            : null;
      });

  // Помечает прочитанными сообщения собеседника в чате [chatId].
  Future<void> markRead(int chatId) =>
      ApiService.I.post<dynamic>('/chat/$chatId/read');

  Future<List<MessageModel>> getMessages(
          int chatId, MessageIndexRequestParams params) =>
      ApiService.I
          .get<dynamic>('/chat/$chatId', queryParameters: params.toData())
          .then((value) => MessageModel.fromJsonList(value.data['list']));
}
