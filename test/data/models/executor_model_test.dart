import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/executor_model.dart';

void main() {
  test('fromJson сохраняет дробный рейтинг', () {
    final executor = ExecutorModel.fromJson({
      'id': 1,
      'name': 'Иван',
      'rating': '4.5',
    });

    expect(executor.rating, 4.5);
  });
}
