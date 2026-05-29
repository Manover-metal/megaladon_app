import 'package:equatable/equatable.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/dictionary/advert_category_model.dart';
import 'package:megaladon/data/models/dictionary/advert_type.dart';
import 'package:megaladon/data/models/dictionary/city_model.dart';
import 'package:megaladon/data/models/dictionary/file_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class AdvertModel extends Equatable {
  const AdvertModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      this.category,
      this.additionalPhone,
      this.city,
      this.media = const [],
      this.user,
      this.type = AdvertType.advert});
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

  static AdvertModel fromJsonMini(data) => AdvertModel(
      id: data['id'] as int,
      title: data['title'] as String,
      description: data['description'] as String,
      price: Parser.toPrice(data['price']),
      media: data['media'] != null ? FileModel.listFromJson(data['media']) : [],
      type: AdvertType.parse(data['type']));

  static List<AdvertModel> listFromJsonMini(List<dynamic> data) =>
      data.map<AdvertModel>(AdvertModel.fromJsonMini).toList();

  static AdvertModel fromJsonAll(Map<String, dynamic> data) => AdvertModel(
      id: data['id'] as int,
      title: data['title'] as String,
      description: data['description'] as String,
      price: Parser.toPrice(data['price']),
      media: data['media'] != null ? FileModel.listFromJson(data['media']) : [],
      category: data['category'] != null
          ? AdvertCategoryModel.fromJson(data['category'])
          : null,
      additionalPhone: data['additional_phone'] as String?,
      user: data['user'] != null
          ? UserModel.fromJson(data['user'] as Map<String, dynamic>)
          : null,
      type: AdvertType.parse(data['type'] as String));

  @override
  List<Object?> get props =>
      [id, title, description, price, category, additionalPhone, media, type];
}
