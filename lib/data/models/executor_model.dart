
import 'package:isar/isar.dart';
import 'package:megaladon/core/utils/parser.dart';

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

  ExecutorModel({
    required this.id,
    required this.name,
    this.rating,
    this.bin,
    this.lat,
    this.lon,
    this.fullAddress,
    this.countOrders
  });

  static ExecutorModel fromJson(data) {
    return ExecutorModel(
        id: data['id'],
        name: data['name'],
        rating: data['rating'],
        bin: data['bin'],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        fullAddress: data['full_address'],
        countOrders: data['count_orders']
    );
  }
}