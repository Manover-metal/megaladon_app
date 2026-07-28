import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/chat/message_model.dart';

void main() {
  test('fromJson парсит file и выводит fileName из URL', () {
    final m = MessageModel.fromJson({
      'id': 1,
      'created_at': '2026-07-13T10:00:00.000000Z',
      'message': null,
      'file': 'https://example.com/storage/chat/abc123.pdf',
    });
    expect(m.file, 'https://example.com/storage/chat/abc123.pdf');
    expect(m.fileName, 'abc123.pdf');
  });

  test('fromJson без file даёт file и fileName null', () {
    final m = MessageModel.fromJson({
      'id': 2,
      'created_at': '2026-07-13T10:00:00.000000Z',
      'message': 'привет',
    });
    expect(m.file, isNull);
    expect(m.fileName, isNull);
    expect(m.text, 'привет');
  });
}
