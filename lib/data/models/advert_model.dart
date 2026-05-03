import 'package:equatable/equatable.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class AdvertModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String price;
  final AdvertCategoryModel? category;
  final CityModel? city;
  final String? additionalPhone;
  final List<FileModel> media;
  final UserModel? user;
  final AdvertType type;

  const AdvertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.category,
    this.additionalPhone,
    this.city,
    this.media = const [],
    this.user,
    this.type = AdvertType.advert
  });

  static AdvertModel fromJsonMini(data) {
    return AdvertModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        price: Parser.toPrice(data['price']),
        media: data['media'] != null? FileModel.listFromJson(data['media']): [],
        type: AdvertType.parse(data['type'])
    );
  }

  static List<AdvertModel> listFromJsonMini(List data) {
    return data.map<AdvertModel>((advert) {
      return AdvertModel.fromJsonMini(advert);
    }).toList();
  }

  static AdvertModel fromJsonAll(data) {
    return AdvertModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      price: Parser.toPrice(data['price']),
      media: data['media'] != null? FileModel.listFromJson(data['media']): [],
      category: data['category'] != null ? AdvertCategoryModel.fromJson(data['category']) : null,
      additionalPhone: data['additional_phone'],
      user: data['user'] != null ? UserModel.fromJson(data['user']) : null,
      type: AdvertType.parse(data['type'])

    );
  }

  @override
  List<Object?> get props => [id, title, description, price, category, additionalPhone, media, type];
}