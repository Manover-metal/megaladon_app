import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/chat/chat_model.dart';
import 'package:megaladon/data/models/chat/message_model.dart';

MessageModel _msg(int id) =>
    MessageModel(id: id, createdAt: DateTime(2026, 1, 1).add(Duration(minutes: id)), text: 'm$id');

ChatModel _chat(List<MessageModel> messages) =>
    ChatModel(id: 1, messages: messages);

void main() {
  test('mergeMessages сортирует сообщения по возрастанию id', () {
    final chat = _chat(const []).mergeMessages([_msg(3), _msg(1), _msg(2)]);

    expect(chat.messages.map((m) => m.id).toList(), [1, 2, 3]);
  });

  test('mergeMessages не создаёт дублей при повторном id (дедуп polling)', () {
    // Первая загрузка
    var chat = _chat(const []).mergeMessages([_msg(1), _msg(2)]);
    // Опрос вернул те же + одно новое
    chat = chat.mergeMessages([_msg(2), _msg(3)]);

    expect(chat.messages.map((m) => m.id).toList(), [1, 2, 3]);
  });

  test('mergeMessages добавляет новые сообщения снизу (polling)', () {
    final chat = _chat([_msg(1), _msg(2)]).mergeMessages([_msg(5)]);

    expect(chat.messages.last.id, 5);
  });

  test('mergeMessages добавляет старые сообщения сверху (пагинация вверх)', () {
    final chat = _chat([_msg(10), _msg(11)]).mergeMessages([_msg(8), _msg(9)]);

    expect(chat.messages.map((m) => m.id).toList(), [8, 9, 10, 11]);
  });

  test('mergeMessages возвращает новый объект, не мутируя исходный', () {
    final original = _chat([_msg(1)]);
    final merged = original.mergeMessages([_msg(2)]);

    expect(original.messages.length, 1);
    expect(merged.messages.length, 2);
    expect(identical(original, merged), isFalse);
  });
}
