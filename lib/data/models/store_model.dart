import 'package:isar/isar.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';

part 'store_model.g.dart';

@collection
class StoreModel {
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

  static StoreModel fromJsonMini(Map<String, dynamic> data) => StoreModel(
      id: data['id'] as int,
      name: data['name'] as String?,
      hasPhone: false,
      rating: data['rating'] as String?,
      fullAddress: data['full_address'] as String,
      photo: data['photo_url'] as String?,
      city: data['city'] != null
          ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
          : null);

  static StoreModel fromJsonFull(Map<String, dynamic> data) {
    var contacts = data['contacts'] != null
        ? ContactModel.fromJsonList(data['contacts'] as List<dynamic>)
        : null;
    return StoreModel(
        id: data['id'] as int,
        rating: data['rating'] as String?,
        bin: Parser.toInt(data['bin']),
        fullAddress: data['full_address'] as String,
        photo: data['photo_url'] as String?,
        name: data['name'] as String?,
        prices: data['prices'] != null
            ? FileModel.listFromJson(data['prices'] as List<dynamic>)
            : [],
        lat: Parser.toDouble(data['lat']),
        lon: Parser.toDouble(data['lon']),
        contacts: contacts,
        hasPhone: (contacts != null) &&
            contacts.any((element) =>
                element.type == ContactType.home_phone ||
                element.type == ContactType.phone),
        city: data['city'] != null
            ? CityModel.fromJson(data['city'] as Map<String, dynamic>)
            : null);
  }

  static StoreModel? fromJsonFullOrNull(Map<String, dynamic>? data) {
    if (data == null) return null;
    try {
      return StoreModel.fromJsonFull(data);
    } catch (e) {
      return null;
    }
  }

  static List<StoreModel> listFromJsonMini(List<dynamic> data) => data
      .map<StoreModel>(
          (item) => StoreModel.fromJsonMini(item as Map<String, dynamic>))
      .toList();
}
