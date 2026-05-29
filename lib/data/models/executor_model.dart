import 'package:isar/isar.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

part 'executor_model.g.dart';

@collection
class ExecutorModel {
  ExecutorModel(
      {required this.id,
      required this.name,
      this.rating,
      this.bin,
      this.lat,
      this.lon,
      this.fullAddress,
      this.countOrders,
      this.photo,
      this.services = const [],
      this.city,
      this.description});
  final Id id;
  final String name;
  final String? rating;
  final String? bin;
  final double? lat;
  final double? lon;
  final String? fullAddress;
  final int? countOrders;
  final String? photo;
  final String? description;

  @ignore
  final CityModel? city;

  @ignore
  final List<ServiceTypeModel> services;

  static ExecutorModel fromJson(data) => ExecutorModel(
      id: data['id'] as int,
      name: data['name'] as String,
      rating: data['rating'] as String?,
      bin: data['bin'] as String?,
      photo: data['photo_url'] as String?,
      lat: Parser.toDouble(data['lat']),
      lon: Parser.toDouble(data['lon']),
      fullAddress: data['full_address'] as String?,
      countOrders: data['count_orders'] as int?,
      services: data['services'] != null
          ? ServiceTypeModel.listFromJson(data['services'] as List<dynamic>)
          : [],
      city: data['city'] != null
          ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
          : null,
      description: data['description'] as String?);

  static ExecutorModel? fromJsonOrNull(Map<String, dynamic>? data) {
    if (data == null) return null;
    try {
      return ExecutorModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  static ExecutorModel fromJsonMini(data) => ExecutorModel(
      id: data['id'] as int,
      name: data['name'] as String,
      rating: data['rating'] as String?,
      city: data['city'] != null
          ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
          : null,
      description: data['description'] as String?);

  static List<ExecutorModel> fromJsonList(List<dynamic> data) {
    print(data);
    return data
        .map<ExecutorModel>(
            (item) => ExecutorModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
