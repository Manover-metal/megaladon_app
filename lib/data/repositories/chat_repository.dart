import 'package:megaladon/core/dio/index.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';
import 'package:megaladon/data/models/request/params/create/message_create_request_params.dart';
import 'package:megaladon/data/models/request/params/index/message_index_request_params.dart';

class ChatRepository {
  Future<List<ChatModel>> index() => ApiService.I
      .get('/chat')
      .then((value) => ChatModel.parseAll(value.data['list']));

  Future createOrder(int orderId, int executorId) => ApiService.I
      .post('/order/$orderId/chat/create', data: { 'executor_id': executorId })
      .then((value) => value.data);

  Future createAdvert(int advertId) => ApiService.I
      .post('/adverts/$advertId/chat/create')
      .then((value) => value.data);

  Future sendMessage(MessageCreateRequestParams params) => ApiService.I
      .post('/chat/send-message', data: params.toData())
      .then((value) => value.data);
  
  Future getMessages(int chatId, MessageIndexRequestParams params) => ApiService.I
      .get('/chat/$chatId', queryParameters: params.toData())
      .then((value) => MessageModel.fromJsonList(value.data['list']));
}

