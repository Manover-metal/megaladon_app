import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

class ExecutorModel {
  ExecutorModel({
    required this.id,
    required this.name,
    this.userId,
    this.description,
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

  /// id пользователя, которому принадлежит профиль исполнителя. Чат
  /// заводится именно по нему: `ChatCubit.createChat` ждёт пользователя, а
  /// не исполнителя.
  final int? userId;
  final String name;
  final String? description;
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
        userId: data['user_id'] as int?,
        name: data['name'] as String,
        description: data['description'] as String?,
        // Parser.toDouble превращает null в 0, поэтому исполнитель без
        // отзывов показывался с «Рейтинг: 0.0», а ветка «Нет оценок» была
        // недостижима. То же и с координатами.
        rating: data['rating'] != null ? Parser.toDouble(data['rating']) : null,
        bin: data['bin'] as String?,
        photo: data['photo_url'] as String?,
        lat: data['lat'] != null ? Parser.toDouble(data['lat']) : null,
        lon: data['lon'] != null ? Parser.toDouble(data['lon']) : null,
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
        'user_id': userId,
        'name': name,
        'description': description,
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
