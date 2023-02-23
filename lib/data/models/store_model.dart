import 'package:megaladon/data/models/dictionary/store_type_model.dart';

class StoreModel {
  final int id;
  final String fullAddress;

  final String? name;
  final int? bin;
  final String? rating;
  final String? photo;
  final List? prices;
  final List? contacts;
  final double? lat;
  final double? lon;
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
    this.type
  });

  static StoreModel fromJsonMini(data) {
    print(data);
    return StoreModel(
        id: data['id'],
        name: data['name'],
        rating: data['rating'],
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        type: data['type'] != null? StoreTypeModel.fromJson(data['type']): null
    );
  }

  static StoreModel fromJsonFull(data) {
    print(data);
    return StoreModel(
        id: data['id'],
        rating: data['rating'],
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        name: data['name'],
        prices: data['prices'],
        contacts: data['contacts'],
        lat: data['lat'],
        lon: data['lon'],
        type: data['type'] != null? StoreTypeModel.fromJson(data['type']): null
    );
  }

  static List<StoreModel> listFromJsonMini(List data) {
    return data.map<StoreModel>((advert) {
      return StoreModel.fromJsonMini(advert);
    }).toList();
  }
}
