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
      required this.store});

  final int id;
  final String name;
  final String? phone;
  final String? photo;
  final int? countOrders;
  final CityModel? city;
  final ExecutorModel? executor;
  final StoreModel? store;

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
          data['executor'] as Map<String, dynamic>),
      store: StoreModel.fromJsonOrNull(data['store'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'photo_url': photo,
        'count_orders': countOrders,
        'city': city?.toJson(),
      };
}
