import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/executor_model.dart';

class OfferModel {
  OfferModel(
      {required this.id,
      required this.price,
      required this.date,
      required this.comment,
      this.city,
      this.executor,
      this.expiredAt});
  final int id;

  /// Число, а не готовая строка: форматирует представление.
  final double price;
  final String date;
  final String? comment;
  final CityModel? city;
  final ExecutorModel? executor;

  /// Докуда предложение в силе. Бэкенд отдаёт `expired_at` и в списке, и в
  /// детальном ответе — до сих пор поле терялось при разборе, и отличить
  /// свежий отклик от протухшего было нельзя.
  final DateTime? expiredAt;

  bool get isExpired =>
      expiredAt != null && expiredAt!.isBefore(DateTime.now());

  /// Цена с разделителями разрядов для показа.
  String get priceText => Parser.toPrice(price);

  static DateTime? _expiredAt(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  static OfferModel fromJsonMini(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as int,
        price: Parser.toDouble(data['price']),
        date: data['date'] as String,
        comment: data['description'] as String?,
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null,
        executor: data['user'] != null
            ? ExecutorModel.fromJson(data['user'] as Map<String, dynamic>)
            : null,
        expiredAt: _expiredAt(data['expired_at']),
      );

  static OfferModel fromJsonFull(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as int,
        price: Parser.toDouble(data['price']),
        date: data['date'] as String,
        comment: data['comment'] as String?,
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null,
        executor: data['user'] != null
            ? ExecutorModel.fromJson(data['user'] as Map<String, dynamic>)
            : null,
        expiredAt: _expiredAt(data['expired_at']),
      );

  static List<OfferModel> listFromJsonMini(List<dynamic> data) => data
      .map<OfferModel>(
          (item) => OfferModel.fromJsonMini(item as Map<String, dynamic>))
      .toList();
}
