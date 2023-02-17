import 'package:equatable/equatable.dart';

class AdvertModel extends Equatable {
  final String title;
  final String description;
  final int price;
  final int categoryId;
  final String additionalPhone;

  const AdvertModel({
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.additionalPhone
  });

  static AdvertModel fromJson(data) {
    return AdvertModel(
        title: data['title'],
        description: data['description'],
        price: data['price'],
        categoryId: data['category_id'],
        additionalPhone: data['additional_phone']
    );
  }

  static List<AdvertModel> listFromJson(List data) {
    return data.map<AdvertModel>((advert) {
      return AdvertModel.fromJson(advert);
    }).toList();
  }

  @override
  List<Object?> get props => [title, description, price, categoryId, additionalPhone];
}