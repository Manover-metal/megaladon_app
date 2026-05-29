import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/executor_model.dart';

class OfferModel {
  OfferModel(
      {required this.id,
      required this.price,
      required this.date,
      required this.comment,
      this.city,
      this.executor});
  final int id;
  final String price;
  final String date;
  final String? comment;
  final CityModel? city;
  final ExecutorModel? executor;

  static OfferModel fromJsonMini(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as int,
        price: Parser.toPrice(data['price']),
        date: data['date'] as String,
        comment: data['description'] as String?,
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null,
        executor: data['user'] != null
            ? ExecutorModel.fromJson(data['user'] as Map<String, dynamic>)
            : null,
      );

  static OfferModel fromJsonFull(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as int,
        price: Parser.toPrice(data['price']),
        date: data['date'] as String,
        comment: data['comment'] as String?,
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null,
        executor: data['user'] != null
            ? ExecutorModel.fromJson(data['user'] as Map<String, dynamic>)
            : null,
      );

  static List<OfferModel> listFromJsonMini(List<dynamic> data) => data
      .map<OfferModel>(
          (item) => OfferModel.fromJsonMini(item as Map<String, dynamic>))
      .toList();
}
