import 'package:isar/isar.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';

import '../../core/utils/parser.dart';

part 'store_model.g.dart';


@collection
class StoreModel {
  final Id id;
  final String fullAddress;

  final String? name;
  final int? bin;
  final String? rating;
  final String? photo;


  final double? lat;
  final double? lon;

  @ignore
  final List? contacts;

  @ignore
  final List? prices;

  @ignore
  final CityModel? city;

  @ignore
  final StoreTypeModel? type;


  StoreModel({
    required this.id,
    required this.fullAddress,
    this.photo,
    this.rating,
    this.prices,
    this.contacts,
    this.bin,
    this.lat,
    this.lon,
    this.name,
    this.type,
    this.city
  });

  static StoreModel fromJsonMini(data) {
    return StoreModel(
        id: data['id'],
        name: data['name'],
        rating: data['rating'],
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        type: data['type'] != null? StoreTypeModel.fromJson(data['type']): null,
        city: data['city'] != null? CityModel.fromJson(data['city']): null

    );
  }

  static StoreModel fromJsonFull(data) {
    return StoreModel(
        id: data['id'],
        rating: data['rating'],
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        name: data['name'],
        prices: data['prices'],
        contacts: data['contacts'],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        type: data['type'] != null? StoreTypeModel.fromJson(data['type']): null,
        city: data['city'] != null? CityModel.fromJson(data['city']): null

    );
  }

  static List<StoreModel> listFromJsonMini(List data) {
    return data.map<StoreModel>((advert) {
      return StoreModel.fromJsonMini(advert);
    }).toList();
  }
}
