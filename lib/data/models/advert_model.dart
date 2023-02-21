import 'package:equatable/equatable.dart';
import 'package:megaladon/core/utils/parser.dart';

class AdvertModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String price;
  final int? categoryId;
  final String? additionalPhone;
  final List media;

  const AdvertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.categoryId,
    this.additionalPhone,
    required this.media
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

  @override
  List<Object?> get props => [id, title, description, price, categoryId, additionalPhone, media];
}