import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';

/// За что указана цена отклика. На бэкенде — `order_offers.price_type`,
/// enum('total', 'per_unit') с умолчанием total: у всех откликов, созданных
/// до появления поля, цена за всю работу.
enum OfferPriceType {
  total('total'),
  perUnit('per_unit');

  const OfferPriceType(this.apiValue);
  final String apiValue;

  /// Незнакомое или пустое значение — как умолчание бэкенда.
  static OfferPriceType fromApi(Object? value) =>
      value == perUnit.apiValue ? perUnit : total;

  /// Подпись рядом с ценой: «за всю работу», «за шт.».
  String localize(AppLocalizations l10n) {
    switch (this) {
      case OfferPriceType.total:
        return l10n.offerPriceTotal;
      case OfferPriceType.perUnit:
        return l10n.offerPricePerUnit;
    }
  }
}

class OfferModel {
  OfferModel(
      {required this.id,
      required this.price,
      required this.date,
      required this.comment,
      this.priceType = OfferPriceType.total,
      this.city,
      this.executor,
      this.executorId,
      this.isFavorite = false,
      this.expiredAt});
  final int id;

  /// id исполнителя автора. [executor] собран из пользователя
  /// (UserPresenter::short), и его `id` — пользовательский; для избранного
  /// нужен именно этот, исполнительский. null — у автора нет профиля
  /// исполнителя или бэкенд старый.
  final int? executorId;

  /// Автор уже в избранном у смотрящего.
  final bool isFavorite;

  /// Число, а не готовая строка: форматирует представление.
  final double price;

  /// За что цена: за всю работу или за штуку.
  final OfferPriceType priceType;
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

  /// Комментарий лежит в колонке `comment`. OfferPresenter долго отдавал его
  /// под ключом `description` из несуществующего поля — то есть всегда null,
  /// а детальный разбор ждал `comment`, которого не было. Теперь бэкенд шлёт
  /// оба ключа; читаем `comment`, `description` — на случай старого бэкенда.
  static String? _comment(Map<String, dynamic> data) =>
      (data['comment'] ?? data['description']) as String?;

  static OfferModel fromJsonMini(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as int,
        executorId: data['executor_id'] as int?,
        isFavorite: data['is_favorite'] == true,
        price: Parser.toDouble(data['price']),
        priceType: OfferPriceType.fromApi(data['price_type']),
        date: data['date'] as String,
        comment: _comment(data),
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
        executorId: data['executor_id'] as int?,
        isFavorite: data['is_favorite'] == true,
        price: Parser.toDouble(data['price']),
        priceType: OfferPriceType.fromApi(data['price_type']),
        date: data['date'] as String,
        comment: _comment(data),
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
