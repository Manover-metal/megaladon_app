import 'package:intl/intl.dart';

class Parser {
  static int toInt(value) {
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    if (value is int) return value;
    return 0;
  }

  static double toDouble(value) {
    if (value is String) return double.tryParse(value) ?? 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0;
  }

  static String toPrice(value) =>
      NumberFormat.decimalPattern().format(toDouble(value));
}
