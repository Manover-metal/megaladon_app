import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:megaladon/data/models/form/price_editing_controller.dart';

void main() {
  test('groupThousands группирует разряды пробелами', () {
    expect(groupThousands('1000000'), '1 000 000');
    expect(groupThousands('100'), '100');
    expect(groupThousands('1000'), '1 000');
    expect(groupThousands(''), '');
  });

  test('конструктор форматирует начальное значение', () {
    expect(PriceEditingController(value: 1000000).text, '1 000 000');
    expect(PriceEditingController().text, '');
  });

  test('number отдаёт чистое число, пустое → null', () {
    expect(PriceEditingController(value: 1000000).number, 1000000);
    expect(PriceEditingController().number, isNull);

    final c = PriceEditingController()..text = '1 234 567';
    expect(c.number, 1234567);
  });

  test('PriceInputFormatter группирует и держит курсор в конце при вводе', () {
    const formatter = PriceInputFormatter();
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: '1000000',
        selection: TextSelection.collapsed(offset: 7),
      ),
    );
    expect(result.text, '1 000 000');
    // курсор после 7 цифр → конец строки '1 000 000'
    expect(result.selection, const TextSelection.collapsed(offset: 9));
  });

  test('PriceInputFormatter сохраняет позицию курсора при вводе в середине', () {
    const formatter = PriceInputFormatter();
    // Было '1 000', пользователь вставил '5' после первой цифры: '15 000',
    // курсор стоит после '5' (offset 2).
    final result = formatter.formatEditUpdate(
      const TextEditingValue(
        text: '1 000',
        selection: TextSelection.collapsed(offset: 1),
      ),
      const TextEditingValue(
        text: '15 000',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    // Цифры '15000' → '15 000'; слева от курсора 2 цифры → offset 2 (после '15').
    expect(result.text, '15 000');
    expect(result.selection, const TextSelection.collapsed(offset: 2));
  });

  test('PriceInputFormatter учитывает вставленный пробел при подсчёте курсора',
      () {
    const formatter = PriceInputFormatter();
    // Ввели 4-ю цифру: '1000' → '1 000'. Курсор был после 4 цифр (offset 4).
    final result = formatter.formatEditUpdate(
      const TextEditingValue(
        text: '100',
        selection: TextSelection.collapsed(offset: 3),
      ),
      const TextEditingValue(
        text: '1000',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    // 4 цифры слева → в '1 000' это offset 5 (перескочили через пробел).
    expect(result.text, '1 000');
    expect(result.selection, const TextSelection.collapsed(offset: 5));
  });
}
