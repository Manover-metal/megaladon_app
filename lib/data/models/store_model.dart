import 'package:isar/isar.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';


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
  final bool hasPhone;

  @ignore
  final List<FileModel> prices;

  @ignore
  final CityModel? city;

  @ignore
  final List<ContactModel>? contacts;


  StoreModel({
    required this.id,
    required this.fullAddress,
    required this.hasPhone,
    this.photo,
    this.rating,
    this.prices = const [],
    this.contacts,
    this.bin,
    this.lat,
    this.lon,
    this.name,
    this.city,
  });

  static StoreModel fromJsonMini(data) {
    
    return StoreModel(
        id: data['id'],
        name: data['name'],
        hasPhone: false,
        rating: data['rating'],
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        city: data['city'] != null? CityModel.fromJson(data['city']): null
    );
  }

  static StoreModel fromJsonFull(data) {

    List<ContactModel>? contacts = data['contacts'] != null? ContactModel.fromJsonList(data['contacts']): null;
    return StoreModel(
        id: data['id'],
        rating: data['rating'],
        bin: Parser.toInt(data['bin']),
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        name: data['name'],
        prices: data['prices'] != null? FileModel.listFromJson(data['prices']): [],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        contacts: contacts,
        hasPhone: (contacts != null)? contacts.any((element) {
          return element.type == ContactType.home_phone || element.type == ContactType.phone;
        }): false,
        city: data['city'] != null? CityModel.fromJson(data['city']): null

    );
  }

  static StoreModel? fromJsonFullOrNull(Map<String, dynamic>? data) {
    if(data == null) return null;
    try {
      return StoreModel.fromJsonFull(data);
    } catch(e) {
      return null;
    }
  }

  static List<StoreModel> listFromJsonMini(List data) {
    return data.map<StoreModel>((advert) {
      return StoreModel.fromJsonMini(advert);
    }).toList();
  }
}
