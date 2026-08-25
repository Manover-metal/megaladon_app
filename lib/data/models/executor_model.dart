import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

class ExecutorModel {
  ExecutorModel({
    required this.id,
    required this.name,
    this.rating,
    this.bin,
    this.lat,
    this.lon,
    this.fullAddress,
    this.countOrders,
    this.photo,
    this.services = const [],
    this.isDeleted = false,
    this.subscriptionExpiredAt,
  });

  final int id;
  final String name;
  final double? rating;
  final String? bin;
  final double? lat;
  final double? lon;
  final String? fullAddress;
  final int? countOrders;
  final String? photo;
  final List<ServiceTypeModel> services;

  /// Аккаунт удалён: бэкенд всё равно отдаёт его в откликах и чатах, но уже
  /// обезличенным — имя «Удалённый аккаунт», без фото, телефона и рейтинга.
  final bool isDeleted;

  /// Окончание оплаченной подписки. `ExecutorPresenter::edited()` отдаёт его
  /// unix-временем в секундах (null, если активного инвойса нет), и только в
  /// полной форме — в `short()` поля нет вовсе. Поэтому у чужих исполнителей
  /// оно всегда null: проверять подписку осмысленно лишь на своём профиле.
  final DateTime? subscriptionExpiredAt;

  /// Подписка куплена и ещё не истекла — исполнителю доступны отклики и звонки.
  bool get hasActiveSubscription =>
      subscriptionExpiredAt?.isAfter(DateTime.now()) ?? false;

  /// Секунды, а не миллисекунды: так это поле приходит с бэкенда и в таком же
  /// виде уходит в localStorage через [toJson].
  static DateTime? _expiredAtFromJson(Object? value) {
    if (value == null) return null;
    final seconds = Parser.toInt(value);
    if (seconds == 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  static ExecutorModel fromJson(Map<String, dynamic> data) => ExecutorModel(
        id: data['id'] as int,
        name: data['name'] as String,
        rating: Parser.toDouble(data['rating'] as dynamic),
        bin: data['bin'] as String?,
        photo: data['photo_url'] as String?,
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        fullAddress: data['full_address'] as String?,
        countOrders: data['count_orders'] as int?,
        services: data['services'] != null
            ? ServiceTypeModel.listFromJson(data['services'] as List<dynamic>)
            : [],
        isDeleted: data['is_deleted'] == true,
        subscriptionExpiredAt:
            _expiredAtFromJson(data['subscription_expired_at']),
      );

  static ExecutorModel? fromJsonOrNull(Map<String, dynamic>? data) {
    if (data == null) return null;
    try {
      return ExecutorModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  static List<ExecutorModel> fromJsonList(List<dynamic> data) => data
      .map<ExecutorModel>(
          (item) => ExecutorModel.fromJson(item as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating,
        'bin': bin,
        'lat': lat,
        'lon': lon,
        'full_address': fullAddress,
        'count_orders': countOrders,
        'photo_url': photo,
        'services': services.map((s) => s.toJson()).toList(),
        'is_deleted': isDeleted,
        'subscription_expired_at': subscriptionExpiredAt == null
            ? null
            : subscriptionExpiredAt!.millisecondsSinceEpoch ~/ 1000,
      };
}
