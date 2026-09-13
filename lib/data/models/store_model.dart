import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';

class StoreModel {
  StoreModel({
    required this.id,
    required this.fullAddress,
    required this.hasPhone,
    this.photo,
    this.rating,
    this.prices = const [],
    this.contacts,
    this.bin,
    this.lat,
    this.lon,
    this.name,
    this.city,
    this.type,
    this.subscriptionExpiredAt,
  });

  final int id;
  final String fullAddress;

  final String? name;
  final String? bin;
  final int? rating;
  final String? photo;
  final double? lat;
  final double? lon;
  final bool hasPhone;
  final List<FileModel> prices;
  final CityModel? city;
  final StoreTypeModel? type;
  final List<ContactModel>? contacts;

  /// Окончание оплаченной подписки. Бэкенд отдаёт его unix-временем в
  /// секундах только для своего магазина (`StorePresenter::edited()`, через
  /// профиль); в каталоге и на чужой карточке поля нет — там всегда null.
  final DateTime? subscriptionExpiredAt;

  /// Подписка куплена и не истекла. Без неё магазин скрыт из каталога.
  bool get hasActiveSubscription =>
      subscriptionExpiredAt?.isAfter(DateTime.now()) ?? false;

  /// Секунды, а не миллисекунды — как у [ExecutorModel]: в таком виде поле
  /// приходит с бэкенда и в таком же уходит в localStorage через [toJson].
  static DateTime? _expiredAtFromJson(Object? value) {
    if (value == null) return null;
    final seconds = Parser.toInt(value);
    if (seconds == 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  /// Первый телефон магазина — по нему звонят из ленты и с карточки.
  ContactModel? get primaryPhone {
    final list = contacts;
    if (list == null) return null;

    for (final contact in list) {
      if (contact.type == ContactType.phone ||
          contact.type == ContactType.home_phone) {
        return contact;
      }
    }

    return null;
  }

  static StoreModel fromJson(Map<String, dynamic> data) {
    var contacts = data['contacts'] != null
        ? ContactModel.fromJsonList(data['contacts'] as List<dynamic>)
        : null;

    return StoreModel(
        id: data['id'] as int,
        // Parser.toInt превращает null в 0, поэтому отсутствие оценок
        // раньше выглядело как «Рейтинг: 0» и ветка «Нет оценок» была
        // недостижима.
        rating: data['rating'] != null ? Parser.toInt(data['rating']) : null,
        bin: data['bin'] as String?,
        fullAddress: data['full_address'] as String,
        photo: data['photo_url'] as String?,
        name: data['name'] as String?,
        prices: data['prices'] != null
            ? FileModel.listFromJson(data['prices'] as List<dynamic>)
            : [],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        contacts: contacts,
        hasPhone: (contacts != null) &&
            contacts.any((element) =>
                element.type == ContactType.home_phone ||
                element.type == ContactType.phone),
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null,
        type: StoreTypeModel.fromJsonOrNull(data['type']),
        subscriptionExpiredAt:
            _expiredAtFromJson(data['subscription_expired_at']));
  }

  static StoreModel? fromJsonOrNull(Map<String, dynamic>? data) =>
      data == null ? null : StoreModel.fromJson(data);

  static List<StoreModel> fromJsonList(List<dynamic> list) => list
      .map((value) => StoreModel.fromJson(value as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bin': bin,
        'full_address': fullAddress,
        'photo_url': photo,
        'rating': rating,
        'lat': lat,
        'lon': lon,
        'prices': prices.map((p) => p.toJson()).toList(),
        'city': city?.toJson(),
        'type': type?.toJson(),
        'contacts': contacts?.map((c) => c.toJson()).toList(),
        'subscription_expired_at': subscriptionExpiredAt == null
            ? null
            : subscriptionExpiredAt!.millisecondsSinceEpoch ~/ 1000,
      };
}
