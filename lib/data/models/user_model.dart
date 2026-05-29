import 'package:isar/isar.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  UserModel({
    required this.id,
    required this.name,
    this.countOrders,
    this.phone,
    this.photo,
    this.city,
  });

  final Id id;
  final String name;
  final String? phone;
  final String? photo;
  final int? countOrders;

  @ignore
  final CityModel? city;

  static UserModel fromJson(Map<String, dynamic> data) => UserModel(
        id: data['id'] as int,
        name: data['name'] as String,
        phone: data['phone'] as String?,
        photo: data['photo_url'] as String? ?? data['image_url'] as String?,
        countOrders: data['count_orders'] as int?,
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null,
      );
}
