import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/executor_model.dart';
import 'package:megaladon/data/models/store_model.dart';

class UserModel {
  UserModel(
      {required this.id,
      required this.name,
      required this.countOrders,
      required this.phone,
      required this.photo,
      required this.city,
      required this.executor,
      required this.store,
      this.createdAt,
      this.isDeleted = false});

  final int id;
  final String name;
  final String? phone;
  final String? photo;
  final int? countOrders;
  final CityModel? city;
  final ExecutorModel? executor;
  final StoreModel? store;

  /// Дата регистрации: приходит только с публичной карточки
  /// (GET /user/{id}/public), в остальных формах ответа её нет.
  final DateTime? createdAt;

  /// Аккаунт удалён: приходит обезличенным (имя «Удалённый аккаунт», без фото
  /// и телефона), но продолжает отдаваться в чатах и откликах.
  final bool isDeleted;

  static UserModel fromJson(Map<String, dynamic> data) => UserModel(
      id: data['id'] as int,
      name: data['name'] as String,
      phone: data['phone'] as String?,
      photo: data['photo_url'] as String? ?? data['image_url'] as String?,
      countOrders: data['count_orders'] as int?,
      city: data['city'] != null
          ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
          : null,
      executor: ExecutorModel.fromJsonOrNull(
          data['executor'] as Map<String, dynamic>?),
      store: StoreModel.fromJsonOrNull(data['store'] as Map<String, dynamic>?),
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
      isDeleted: data['is_deleted'] == true);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'photo_url': photo,
        'count_orders': countOrders,
        'city': city?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'is_deleted': isDeleted,
      };
}
