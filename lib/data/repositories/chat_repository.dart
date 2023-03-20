import 'package:megaladon/core/dio/index.dart';

class ChatRepository {
  Future index() => ApiService.I
      .get('/chat')
      .then((value) => value.data);
}