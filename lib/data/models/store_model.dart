import 'package:isar/isar.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/dictionary/store_type_model.dart';


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
  final StoreTypeModel? type;

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
    this.type,
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
        type: Parser.toStoreType(data['type']),
        city: data['city'] != null? CityModel.fromJson(data['city']): null
    );
  }

  static StoreModel fromJsonFull(data) {

    List<ContactModel>? contacts = data['contacts'] != null? ContactModel.fromJsonList(data['contacts']): null;
    return StoreModel(
        id: data['id'],
        rating: data['rating'],
        fullAddress: data['full_address'],
        photo: data['photo_url'],
        name: data['name'],
        prices: data['prices'] != null? FileModel.listFromJson(data['prices']): [],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        contacts: contacts,
        hasPhone: (contacts != null)? contacts.any((element) {
          return element.type == ContactType.homePhone || element.type == ContactType.phone;
        }): false,
        type: Parser.toStoreType(data['type']),
        city: data['city'] != null? CityModel.fromJson(data['city']): null

    );
  }

  static List<StoreModel> listFromJsonMini(List data) {
    return data.map<StoreModel>((advert) {
      return StoreModel.fromJsonMini(advert);
    }).toList();
  }
}
