import 'package:megaladon/core/utils/parser.dart';

enum SubscribeType {
  executor, store;

  static SubscribeType parse(data) {
    if(data == 'executor') {
      return executor;
    } else  {
      return store;
    }
  }
}

class SubscribeModel {
  final int id;
  final SubscribeType type;
  final String duration;
  final double price;

  SubscribeModel({
    required this.id,
    required this.type,
    required this.duration,
    required this.price
  });

  static SubscribeModel fromJson(data) {
    return SubscribeModel(
      id: data['id'],
      type: SubscribeType.parse(data['name']),
      duration: data['duration'],
      price: Parser.toDouble(data["price"])
    );
  }

  static List<SubscribeModel> listFromJson(data) {
    return data.map<SubscribeModel>((sub) => SubscribeModel.fromJson(sub)).toList();
  }
}