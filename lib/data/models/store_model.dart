import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/contact_model.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';

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

  final int id;
  final String fullAddress;

  final String? name;
  final String? bin;
  final int? rating;
  final String? photo;
  final double? lat;
  final double? lon;
  final bool hasPhone;
  final List<FileModel> prices;
  final CityModel? city;
  final List<ContactModel>? contacts;

  static StoreModel fromJson(Map<String, dynamic> data) {
    var contacts = data['contacts'] != null
        ? ContactModel.fromJsonList(data['contacts'] as List<dynamic>)
        : null;

    return StoreModel(
        id: data['id'] as int,
        rating: Parser.toInt(data['rating']),
        bin: data['bin'] as String?,
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

  static StoreModel? fromJsonOrNull(Map<String, dynamic>? data) =>
      data == null ? null : StoreModel.fromJson(data);

  static List<StoreModel> fromJsonList(List<dynamic> list) => list
      .map((value) => StoreModel.fromJson(value as Map<String, dynamic>))
      .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bin': bin,
        'full_address': fullAddress,
        'photo_url': photo,
        'rating': rating,
        'lat': lat,
        'lon': lon,
        'prices': prices.map((p) => p.toJson()).toList(),
        'city': city?.toJson(),
        'contacts': contacts?.map((c) => c.toJson()).toList(),
      };
}
