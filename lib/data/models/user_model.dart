import 'package:isar/isar.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/executor_model.dart';

part 'user_model.g.dart';


@collection
class UserModel {

  final Id id;
  final String name;
  final String? phone;
  final String? photo;
  final int? countOrders;

  @ignore
  final CityModel? city;

  UserModel({
    required this.id,
    required this.name,
    this.countOrders,
    this.phone,
    this.photo,
    this.city,
  });

  static UserModel fromJson(data) {
    print(data);
    return UserModel(
      id: data['id'],
      name: data['name'],
      phone: data['phone'],
      photo: data['photo_url'],
      countOrders: data['count_orders'],
      city: data['city'] != null? CityModel.fromJson(data['city']): null,
    );
  }
}