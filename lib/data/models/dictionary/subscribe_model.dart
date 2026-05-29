import 'package:megaladon/core/utils/parser.dart';

enum SubscribeType {
  executor,
  store;

  static SubscribeType parse(data) {
    if (data == 'executor') {
      return executor;
    } else {
      return store;
    }
  }
}

class SubscribeModel {
  SubscribeModel(
      {required this.id,
      required this.type,
      required this.duration,
      required this.price});
  final int id;
  final SubscribeType type;
  final String duration;
  final double price;

  static SubscribeModel fromJson(Map<String, dynamic> data) => SubscribeModel(
      id: data['id'] as int,
      type: SubscribeType.parse(data['name'] as String),
      duration: data['duration'] as String,
      price: Parser.toDouble(data['price']));

  static List<SubscribeModel> listFromJson(List<dynamic> data) => data
      .map<SubscribeModel>(
          (item) => SubscribeModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
