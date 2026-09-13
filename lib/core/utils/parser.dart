import 'package:intl/intl.dart';

class Parser {
  static int toInt(value) {
    if (value is String)
      return int.tryParse(value.replaceAll(',', '').split('.').first) ?? 0;
    if (value is double) return value.toInt();
    if (value is int) return value;
    return 0;
  }

  static double toDouble(value) {
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0;
  }

  /// Цена в виде «20 000»: разряды разделяются неразрывным пробелом, чтобы
  /// число не переносилось по строкам. NumberFormat даёт запятую, поэтому
  /// подменяем разделитель после форматирования.
  static String toPrice(Object? value) => NumberFormat('#,###')
      .format(toDouble(value).toInt())
      .replaceAll(',', '\u00A0');

  /// Дата в том же виде, в каком её отдаёт бэкенд у заказов (`d.m.Y`).
  /// Объявлениям `created_at` приходит сырым timestamp'ом, поэтому формат
  /// приводим на клиенте — иначе в ленте оказалась бы строка вида
  /// «2026-09-12T10:33:00.000000Z».
  static String? toDate(Object? value) {
    if (value is! String) return null;

    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;

    return DateFormat('dd.MM.yyyy').format(parsed.toLocal());
  }
}
