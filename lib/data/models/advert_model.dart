import 'package:equatable/equatable.dart';
import 'package:megaladon/core/utils/parser.dart';
import 'package:megaladon/data/models/category_model.dart';
import 'package:megaladon/data/models/user_model.dart';

class AdvertModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String price;
  final CategoryModel? category;
  final String? additionalPhone;
  final List media;
  final UserModel? user;

  const AdvertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.category,
    this.additionalPhone,
    required this.media,
    this.user
  });

  static AdvertModel fromJsonMini(data) {
    print(data);
    return AdvertModel(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        price: data['price'],
        media: data['media'],
    );
  }

  static List<AdvertModel> listFromJsonMini(List data) {
    print(data);
    return data.map<AdvertModel>((advert) {
      return AdvertModel.fromJsonMini(advert);
    }).toList();
  }

  static AdvertModel fromJsonAll(data) {
    print(data);
    return AdvertModel(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      price: data['price'],
      media: data['media'],
      category: data['category'] != null? CategoryModel.fromJson(data['category']) : null,
      additionalPhone: data['additional_phone'],
      user: data['user'] != null? UserModel.fromJson(data['user']): null
    );
  }

  @override
  List<Object?> get props => [id, title, description, price, category, additionalPhone, media];
}