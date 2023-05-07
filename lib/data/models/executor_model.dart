
import 'package:isar/isar.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/service_type_model.dart';

part 'executor_model.g.dart';


@collection
class ExecutorModel {
  final Id id;
  final String name;
  final String? rating;
  final String? bin;
  final double? lat;
  final double? lon;
  final String? fullAddress;
  final int? countOrders;
  final String? photo;
  
  @ignore
  final List<ServiceTypeModel> services;


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
    this.services = const []
  });

  static ExecutorModel fromJson(data) {
    return ExecutorModel(
        id: data['id'],
        name: data['name'],
        rating: data['rating'],
        bin: data['bin'],
        photo: data['photo_url'],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        fullAddress: data['full_address'],
        countOrders: data['count_orders'],
        services: data['services'] != null? ServiceTypeModel.listFromJson(data['services']): []
    );
  }

  static List<ExecutorModel> fromJsonList(data) {
    print(data);
    return data.map<ExecutorModel>((executor) {
      return ExecutorModel.fromJson(executor);
    }).toList();
  }
}