import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/executor_model.dart';

class OfferModel {
  final int id;
  final String price;
  final String date;
  final String expiredAt;
  final String? comment;
  final CityModel? city;
  final ExecutorModel? executor;

  OfferModel({
    required this.id,
    required this.price,
    required this.date,
    required this.expiredAt,
    required this.comment,
    this.city,
    this.executor
  });

  static OfferModel fromJsonMini(data) {
    return OfferModel(
      id: data['id'],
      price: Parser.toPrice(data['price']),
      date: data['date'],
      comment: data['description'],
      expiredAt: data['expired_at'],
      city: data['city'] != null? CityModel.fromJson(data['city']): null,
      executor: data['user'] != null? ExecutorModel.fromJson(data['user']): null,
    );
  }

  static OfferModel fromJsonFull(data) {
    return OfferModel(
      id: data['id'],
      price: Parser.toPrice(data['price']),
      date: data['date'],
      expiredAt: data['expired_at'],
      comment: data['comment'],
      city: data['city'] != null? CityModel.fromJson(data['city']): null,
      executor: data['user'] != null? ExecutorModel.fromJson(data['user']): null,
    );
  }

  static List<OfferModel> listFromJsonMini(List data) {
    return data.map<OfferModel>((advert) {
      return OfferModel.fromJsonMini(advert);
    }).toList();
  }
}