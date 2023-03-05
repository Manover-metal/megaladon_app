import 'package:megaladon/data/models/dictionary/city_model.dart';

class OfferModel {
  final int id;
  final String price;
  final String date;
  final String comment;
  final CityModel? city;

  OfferModel({
    required this.id,
    required this.price,
    required this.date,
    required this.comment,
    this.city
  });

  static OfferModel fromJsonMini(data) {
    print(data);
    return OfferModel(
      id: data['id'],
      price: data['price'],
      date: data['date'],
      comment: data['comment'],
    );
  }

  static OfferModel fromJsonFull(data) {
    print(data);
    return OfferModel(
      id: data['id'],
      price: data['price'],
      date: data['date'],
      comment: data['comment'],
    );
  }

  static List<OfferModel> listFromJsonMini(List data) {
    return data.map<OfferModel>((advert) {
      return OfferModel.fromJsonMini(advert);
    }).toList();
  }
}