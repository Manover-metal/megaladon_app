import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Группирует строку из цифр по 3 разряда справа, разделитель — пробел.
/// `'1000000'` → `'1 000 000'`, `''` → `''`.
String groupThousands(String digits) {
  if (digits.isEmpty) return '';
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Контроллер поля цены: хранит отформатированный текст с разделителями
/// разрядов, но отдаёт чистое число через [number]. Форматирование
/// инкапсулировано здесь и в [PriceInputFormatter].
class PriceEditingController extends TextEditingController {
  PriceEditingController({int? value})
      : super(text: value != null ? groupThousands('$value') : '');

  /// Чистое число без разделителей; `null`, если поле пустое.
  int? get number {
    final digits = text.replaceAll(RegExp('[^0-9]'), '');
    return digits.isEmpty ? null : int.parse(digits);
  }
}

bool _isDigit(String ch) {
  final code = ch.codeUnitAt(0);
  return code >= 0x30 && code <= 0x39;
}

/// Форматтер: снимает нецифры, группирует разряды пробелами и сохраняет
/// позицию курсора по числу цифр слева от него (с учётом вставленных пробелов).
class PriceInputFormatter extends TextInputFormatter {
  const PriceInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final formatted = groupThousands(digits);

    // Сколько цифр стоит слева от курсора во вводимом тексте.
    final base = newValue.selection.baseOffset;
    final cursor = base < 0 ? newValue.text.length : base;
    var digitsBeforeCursor = 0;
    for (var i = 0; i < cursor && i < newValue.text.length; i++) {
      if (_isDigit(newValue.text[i])) digitsBeforeCursor++;
    }

    // Позиция в отформатированной строке после стольких же цифр
    // (проскакиваем добавленные пробелы).
    var offset = 0;
    var seen = 0;
    while (offset < formatted.length && seen < digitsBeforeCursor) {
      if (_isDigit(formatted[offset])) seen++;
      offset++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
