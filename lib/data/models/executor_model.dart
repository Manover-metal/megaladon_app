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
  });

  final int id;
  final String name;
  final String? rating;
  final String? bin;
  final double? lat;
  final double? lon;
  final String? fullAddress;
  final int? countOrders;
  final String? photo;
  final List<ServiceTypeModel> services;

  static ExecutorModel fromJson(Map<String, dynamic> data) => ExecutorModel(
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
      };
}
